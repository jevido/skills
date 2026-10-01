package main

import (
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"github.com/AllUnited-nl/docs/services/api/app/docs"
)

// Renders every out/*.md and reports leftover component tags (unexpanded)
// and internal links to slugs that are not in the out/ set or the known list.
func main() {
	dir := os.Args[1]
	files, _ := filepath.Glob(filepath.Join(dir, "*.md"))
	slugs := map[string]bool{}
	for _, f := range files {
		slugs[strings.ReplaceAll(strings.TrimSuffix(filepath.Base(f), ".md"), "__", "/")] = true
	}
	for _, s := range os.Args[2:] {
		slugs[s] = true
	}
	tag := regexp.MustCompile(`&lt;/?(Callout|Cards|Card|Tabs|Tab|Steps|Step|Accordions|Accordion|Files|File|Folder)\b`)
	link := regexp.MustCompile(`href="/p/au/([^"#?]*)`)
	for _, f := range files {
		b, _ := os.ReadFile(f)
		_, body := docs.SplitFrontMatter(string(b))
		r, err := docs.Render(body)
		name := filepath.Base(f)
		if err != nil {
			fmt.Println(name, "ERROR", err)
			continue
		}
		for _, m := range tag.FindAllString(r.HTML, -1) {
			fmt.Println(name, "UNEXPANDED", m)
		}
		if strings.Contains(r.HTML, "<Callout") || strings.Contains(r.HTML, "<Card ") {
			fmt.Println(name, "RAW TAG LEFT")
		}
		for _, m := range link.FindAllStringSubmatch(r.HTML, -1) {
			s := strings.TrimSuffix(m[1], "/")
			if !slugs[s] {
				fmt.Println(name, "DEAD LINK", s)
			}
		}
	}
}
