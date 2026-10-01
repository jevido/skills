// Command nlcheck compares Dutch pages (<nl>/<name>.nl.md) with their English
// source (<en>/<name>.md): same headings, tables, code blocks and components,
// every internal link in /p/au/nl, no dead links. With -fix it rewrites
// #anchors in Dutch links to the Dutch heading at the same position as the
// English heading the anchor named (the translator keeps English anchors).
//
//	go run . [-fix] <en dir> <nl dir>
package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/AllUnited-nl/docs/services/api/app/docs"
)

var (
	headingID = regexp.MustCompile(`<h[1-6][^>]* id="([^"]+)"`)
	hrefRe    = regexp.MustCompile(`href="/p/au(/[^"]*)?"`)
	fence     = regexp.MustCompile("(?m)^\\s*```")
	tableRow  = regexp.MustCompile(`<tr>`)
	component = regexp.MustCompile(`<(Callout|Cards|Card|Tabs|Tab|Steps|Step|Accordions|Accordion|Files|File|Folder)\b`)
	unexpand  = regexp.MustCompile(`&lt;/?(Callout|Cards|Card|Tabs|Tab|Steps|Step|Accordions|Accordion|Files|File|Folder)\b`)
	// A Markdown or href link to an au page with an anchor, in the raw text.
	anchorLink = regexp.MustCompile(`/p/au/nl((?:/[A-Za-z0-9_.-]+)*)#([A-Za-z0-9_\-%]+)`)
	selfAnchor = regexp.MustCompile(`\]\(#([A-Za-z0-9_\-%]+)\)`)
)

type page struct {
	raw  string
	html string
	ids  []string
}

func load(path string) (*page, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	_, body := docs.SplitFrontMatter(string(b))
	r, err := docs.Render(body)
	if err != nil {
		return nil, err
	}
	p := &page{raw: string(b), html: r.HTML}
	for _, m := range headingID.FindAllStringSubmatch(r.HTML, -1) {
		p.ids = append(p.ids, m[1])
	}
	return p, nil
}

func slugOf(name string) string {
	s := strings.TrimSuffix(strings.TrimSuffix(name, ".md"), ".nl")
	if s == "_root" {
		return ""
	}
	return strings.ReplaceAll(s, "__", "/")
}

func main() {
	fix := flag.Bool("fix", false, "rewrite anchors in the Dutch files")
	flag.Parse()
	enDir, nlDir := flag.Arg(0), flag.Arg(1)

	en := map[string]*page{}
	enFiles, _ := filepath.Glob(filepath.Join(enDir, "*.md"))
	for _, f := range enFiles {
		p, err := load(f)
		if err != nil {
			fmt.Println(filepath.Base(f), "EN ERROR", err)
			continue
		}
		en[slugOf(filepath.Base(f))] = p
	}
	nl := map[string]*page{}
	nlPath := map[string]string{}
	nlFiles, _ := filepath.Glob(filepath.Join(nlDir, "*.nl.md"))
	for _, f := range nlFiles {
		p, err := load(f)
		if err != nil {
			fmt.Println(filepath.Base(f), "ERROR", err)
			continue
		}
		s := slugOf(filepath.Base(f))
		nl[s], nlPath[s] = p, f
	}

	// mapAnchor turns the English anchor a on page slug into the Dutch one.
	mapAnchor := func(slug, a string) (string, string) {
		e, n := en[slug], nl[slug]
		if e == nil {
			return "", "DEAD LINK /p/au/nl/" + slug
		}
		if n == nil {
			return "", "" // not translated yet: fix on a later run
		}
		for i, id := range e.ids {
			if id == a {
				if i < len(n.ids) {
					return n.ids[i], ""
				}
				return "", "HEADING COUNT for anchor " + slug + "#" + a
			}
		}
		for _, id := range n.ids {
			if id == a {
				return a, "" // already Dutch
			}
		}
		return "", "DEAD ANCHOR " + slug + "#" + a
	}

	missing := 0
	for slug := range en {
		if nl[slug] == nil {
			missing++
		}
	}
	for slug, n := range nl {
		name := filepath.Base(nlPath[slug])
		say := func(f string, a ...any) { fmt.Println(name, fmt.Sprintf(f, a...)) }
		e := en[slug]
		if e == nil {
			say("NO ENGLISH SOURCE")
			continue
		}
		if len(e.ids) != len(n.ids) {
			say("HEADINGS en=%d nl=%d", len(e.ids), len(n.ids))
		}
		if a, b := len(fence.FindAllString(e.raw, -1)), len(fence.FindAllString(n.raw, -1)); a != b {
			say("CODE FENCES en=%d nl=%d", a, b)
		}
		if a, b := len(tableRow.FindAllString(e.html, -1)), len(tableRow.FindAllString(n.html, -1)); a != b {
			say("TABLE ROWS en=%d nl=%d", a, b)
		}
		if a, b := len(component.FindAllString(e.raw, -1)), len(component.FindAllString(n.raw, -1)); a != b {
			say("COMPONENTS en=%d nl=%d", a, b)
		}
		for _, m := range unexpand.FindAllString(n.html, -1) {
			say("UNEXPANDED %s", m)
		}
		if r := float64(len(strings.Fields(n.raw))) / float64(len(strings.Fields(e.raw))); r < 0.8 {
			say("SHORT: %.0f%% of the English word count", r*100)
		}
		for _, m := range hrefRe.FindAllStringSubmatch(n.html, -1) {
			path, _, _ := strings.Cut(m[1], "#")
			if path != "/nl" && !strings.HasPrefix(path, "/nl/") {
				say("ENGLISH LINK /p/au%s", m[1])
				continue
			}
			target := strings.Trim(strings.TrimPrefix(path, "/nl"), "/")
			if en[target] == nil {
				say("DEAD LINK /p/au/nl/%s", target)
			}
		}
		raw := anchorLink.ReplaceAllStringFunc(n.raw, func(s string) string {
			m := anchorLink.FindStringSubmatch(s)
			target := strings.Trim(m[1], "/")
			to, problem := mapAnchor(target, m[2])
			if problem != "" {
				say("%s", problem)
			}
			if to == "" {
				return s
			}
			return "/p/au/nl" + m[1] + "#" + to
		})
		raw = selfAnchor.ReplaceAllStringFunc(raw, func(s string) string {
			a := selfAnchor.FindStringSubmatch(s)[1]
			to, problem := mapAnchor(slug, a)
			if problem != "" {
				say("%s", problem)
			}
			if to == "" {
				return s
			}
			return "](#" + to + ")"
		})
		if *fix && raw != n.raw {
			if err := os.WriteFile(nlPath[slug], []byte(raw), 0o644); err != nil {
				say("WRITE %v", err)
			} else {
				say("FIXED anchors")
			}
		}
	}
	fmt.Printf("%d Dutch pages, %d English pages without a translation\n", len(nl), missing)
}
