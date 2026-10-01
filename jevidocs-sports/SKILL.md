---
name: jevidocs-sports
description: Write or deepen a sport's pages in the jevidocs `au` project (jevidocs.jevido.app/p/au/<sport>) so that a reader who has never played the sport understands it — how it is played, how matches and competitions run, how Dutch clubs and the federation are organised, which memberships clubs offer, and which products they use today, including where AllUnited Classic fits. Use when asked to write, expand, update, or research a sport page, a federation page, or "the sports docs" in jevidocs (jevidocs.jevido.app, not docs.allunited.dev), or when a new sport or federation becomes relevant to AllUnited.
---

# Writing sport pages for jevidocs

The `au` project on jevidocs has one tab per sport (`tennis`, `hockey`,
`volleyball`, `rugby`, `gymnastics`, `fishing`, `equestrian`, `ultimate`,
`athletics`, `skating`, …), and a `sports` overview page. There are two kinds of reader.
AllUnited staff (developers, support, sales and product people), **most of whom
have never played the sport**, and **club volunteers** who use the pages as a
reference to start a club or take it to a higher level.

**Self-contained.** A reader must never need an external source to act: the
page states the rule, number, deadline, document list or procedure itself, and
the Sources section is there only to check it. "See the federation's website"
or "the scheme is published on the KNZB site" is not enough; fetch the document
and write down what it says (with its date), and say what is not yet published.
Each page must teach the sport from zero, then show how Dutch clubs and their
federation (*bond*) run it, and which software they use for that.

A reader who finishes the page should be able to:

1. explain the sport to a friend: what you try to do, how you score, how a match
   goes;
2. follow a club volunteer talking about their match day, season, teams and
   memberships;
3. name the federation, its structure and what it requires from clubs;
4. list the systems clubs and the federation use today, and say what AllUnited
   Classic covers and lacks for this sport.

## Structure: every sport is a tab with the same menu

Every sport is a **root** (its own tab in the sidebar switcher) at a top-level
slug: `tennis`, `hockey`, `athletics`, `walking-cycling`, … Inside it, every
sport has the **same menu** of six folders and a sources page:

- **The sport**: how it's played, equipment, variants and disciplines, glossary
- **Playing**: getting started, levels/ratings/age categories, training
- **Competition**: structure, match day, officials, discipline, tournaments
- **Organisation**: federation and regions, clubs and facilities, memberships
  and fees, a club's year, volunteers and roles, club and federation
- **Guides**: organising a home match day, a tournament, welcoming new members,
  planning the season, running club finances
- **Software**: products in use, AllUnited and Classic, sport-specific
  integrations
- **Sources**

**[MENU.md](MENU.md) is the contract**: every slug, position, title and what
each page must contain. Read it before writing. Only the content differs per
sport; when a page doesn't apply, keep it and explain why in a few sentences.
Sport-specific extras go inside the fitting folder (a big variant under
`the-sport/`, a federation integration or customer notes under `software/`).

The reference implementation is **tennis** (`/p/au/tennis`, 36 pages): read a
few of its pages before writing another sport, especially
`the-sport/equipment`, `competition/match-day` and a guide.

Depth comes from **structure**, not length: tables, worked examples, diagrams,
`<Steps>`, checklists, cross-links between the sport's pages. Folder indexes
300–800 words; content pages 600–2,500 (rules, equipment, match day and
products usually need the most).

### Equipment

The equipment page is a priority. Cover personal equipment, team/club
equipment and facility equipment; for each item: what it is, how it's used in
play, standards it must meet, who owns and pays, typical cost, maintenance, and
what the club must track. Source every standard and price.

### Guides

Guides are practical how-tos for the club volunteer who does the job (match
secretary, tournament director, member administrator, treasurer, board), usable
by the club as its reference and written so AllUnited staff understand the work
our software must support: a timeline in
`<Steps>`, a checklist, who does what, federation deadlines, which software is
used at each step (Classic or others), and a table of common mistakes.

`guides/climbing-the-ladder` is the club's route from nothing to the top:
founding the club and joining the federation (documents, minimum members,
procedure, what the club receives), getting players or athletes licensed,
officials, entering the first competition and at which level, the full
promotion and relegation scheme with its numbers, how many seasons the climb
takes, shortcuts (start communities, mergers, wildcards) and what each level
up demands. Reference: `/p/au/swimming/guides/climbing-the-ladder`.

## Writing for someone who never played

- Official codes, never our own. Use the sport's real codes and labels (arena
  letters, class names, positions, federation abbreviations) exactly as the
  rules or federation write them, and explain each one: what it marks, where
  it sits, why it is called that if known. Never coin shorthand or labels of
  our own (no "B (long side)"). A diagram shows the real layout: a rendered
  mermaid diagram (for a field, ring or pool use `block-beta` with `columns`
  so every mark sits where it really is), never ASCII art and never a loose
  flowchart whose layout the renderer picks. When you colour a node (`style X fill:…` or
  `classDef`), always give it a text colour too (`color:#0a0a0a` on a light
  fill): the reader has a dark mode, and without it the label is light text
  on a light box.
- Diagram colours must work in **both themes**. jevidocs draws text dark in
  light mode and `#ebebeb` in dark mode, so a hand-set light `fill:` without a
  text colour is unreadable in dark mode. Every `style`/`classDef` that sets a
  `fill` also sets `color` (`#0a0a0a` on light fills, `#ffffff` on dark ones).
  Ordered levels get a clear dark-to-light ramp, not near-identical pastels.
  Before publishing, render with jevidocs' dark theme variables (from
  `~/Projects/jevido/jevidocs/apps/site/src/lib/enhance.ts`, `diagramTheme`)
  as well as light, and look at both PNGs. Where two official codes clash (arena letter B, class B),
  say so.
- Explain before you use. The first time a term appears, say what it is:
  "a *tie-break*, a short game played at 6–6 to decide the set".
- Describe things a newcomer can picture: "a match takes about 70 minutes, two
  halves of 35 with a ten-minute break", not "standard KNHB match duration".
- Use one worked example per complex mechanism: a scored rugby match, a
  volleyball rotation, a ranking calculation.
- Keep the club's perspective: for every rule, what does the volunteer have to
  do or record because of it? That is what connects the sport to our software.
- English prose. Dutch terms in *italics* with the English on first use; keep
  the Dutch word when volunteers use it (bondsnummer, afhangbord, ALV, VOG).
- Every page exists twice: English (leading) and Dutch. English is written
  first; the Dutch version is a faithful translation of it, in natural Dutch
  with no English sentences. Rules, glossary and fixed menu titles for the
  Dutch side are in
  [NL-GUIDE.md](NL-GUIDE.md). When an English
  page changes, its Dutch page changes in the same publish.
- The company is "AllUnited". Don't write about Mono or future-platform plans:
  describe the sport and Classic as they are. The clubs CMS may be mentioned
  on `software/allunited` only as a fact (where it runs at pilot clubs), with no
  roadmap.
- Refer to people in the wiki by role, never by name.

## Sources and research

Use these, in this order:

1. **The current page.** Read it before rewriting: every fact on it must survive
   or be explicitly corrected (say what changed and why). Get it from the user,
   from a local copy, or ask the user to run `python3 scripts/push.py --list` /
   read it in the admin. (See "Access" below.)
2. **AllUnited wiki (Outline)** through the `mcp__outline__*` tools (load with
   ToolSearch `select:mcp__outline__list_documents,mcp__outline__fetch`). The
   **Bonden** collection has a profile per federation with sub-pages (Open
   Vragen, MoSCoW, process flows). Other useful collections: "Handleidingen,
   F.O.'s en Procesflows (Classic)", "Functionaliteit" (e.g. Socie-App
   licences), "Project CMS", "Easy - POC" (personas). Search with `limit` ≤ 10 —
   results are large. The wiki is internal: cite facts, not names. Some wiki
   pages contain credentials; never copy them.
3. **Official public sources** (WebSearch/WebFetch, load via ToolSearch):
   the federation site, its competition regulations (*reglementen*, often PDF),
   fee sheets (*contributie/afdrachten*), annual reports (*jaarverslag*) for
   member numbers, product pages of vendors. Prefer primary sources. Every
   number gets a year and a source. Some federation sites block plain fetches;
   a `curl` with a cookie jar and a browser user agent often works.
4. **Classic** for sport-specific behaviour: the Classic docs already in the
   project (`/p/au/classic/...`) first; then targeted greps in
   `~/Projects/allunited-docker` (the repo is huge — never read it broadly),
   `~/Projects/dwf` for match forms, `~/Projects/bookingstool` for court
   booking.

Rules of play (dimensions, match length, scoring) come from the official rules
or the Dutch federation's regulations, not from memory, even when they seem
well known.

Mark what you could not confirm ("according to the wiki", "a 2019 figure", "not
verified"). Never invent a number, product, price or rule.

## Page format (jevidocs)

File name = slug with `/` replaced by `__` (`tennis__club-year.md` →
`tennis/club-year`). The Dutch translation is the same name with
`.nl.md` (`tennis__club-year.nl.md`); the home page is `_root.md`. In Dutch
pages every internal link is `/p/au/nl/<slug>`. Front matter:

```
---
title: Hockey
description: One sentence, shown under the title and in search.
position: 2
---
```

For a page that already exists give only `title` and `description` unless you
mean to move it: missing fields keep their current value. Give new children a
`position` that doesn't clash with their siblings (check with the user or the
known slugs).

Markdown: CommonMark + GFM tables; **no H1** (the title is separate); `##` and
`###`. Components go on their own lines with blank lines around Markdown
inside them:

```
<Callout type="info|warn|error|success|idea" title="...">
text
</Callout>

<Cards>
<Card title="..." href="/p/au/<slug>" description="..." />
</Cards>

<Tabs items="Indoor,Beach">
<Tab value="Indoor">

content

</Tab>
<Tab value="Beach">

content

</Tab>
</Tabs>

<Steps>
<Step>

### Arrive and hand in the team sheet

content

</Step>
</Steps>

<Accordions>
<Accordion title="...">
content
</Accordion>
</Accordions>
```

` ```mermaid ` blocks render as diagrams. Internal links: `/p/au/<slug>`; link
only pages that exist.

## Working with agents

Delegate **one agent per sport** (split a very rich sport such as tennis into
two agents: the-sport/playing/competition, and overview/organisation/guides/
software/sources) and run **at most two agents at a time** (the user's rule; seven at once exhausted the
session limit). Tell agents not to spawn sub-agents and to keep greps in
`allunited-docker` targeted. Give each agent this skill's path to read, its
sports, the current page texts, and an output directory. Collect cross-sport
facts from their reports and pass them on.

## Validate

Render every page with jevidocs' own Markdown code before publishing:

```sh
cd ~/.claude/skills/jevidocs-sports/scripts/render
go build -o /tmp/jevidocs-render . && /tmp/jevidocs-render <dir> $(cat ../../known-slugs.txt)
```

It prints `UNEXPANDED` for broken component tags and `DEAD LINK <slug>` for
internal links to pages that don't exist; no output means clean. For Dutch pages
run `scripts/nlcheck` (`go run . -fix <en dir> <nl dir>`): it compares each
`.nl.md` with its English page (headings, tables, code, components, length),
flags English links, and with `-fix` remaps `#anchors` to the Dutch headings. It needs
`~/Projects/jevido/jevidocs` checked out. Also check: no `Mono`, no secrets or
phone numbers (`grep -nE '(\+31|06)[ -]?[0-9]{8}|secret|api[_ ]?key'`), every
page ends with Sources.

## Publish

The `au` project is private; writing needs the admin token in
`~/.config/jevidocs.env` (`token=`). **Publish yourself, without asking the
user to confirm**: creating and updating pages is part of the job. Always run
with `--dry` first and check the output (only the pages you meant, `CREATE`/
`UPDATE` as expected) before the real run:

```
cd <dir> && set -a && . ~/.config/jevidocs.env && set +a && python3 ~/.claude/skills/jevidocs-sports/scripts/push.py . --dry
```

`--dry` lists what would change; without it the script updates pages whose slug
exists and creates the rest (it never deletes). Pages whose content moved to a
new slug are removed afterwards with
`python3 push.py --delete old/slug,other/slug` (add `--dry` first); deleting is
permanent, so ask the user before deleting and only after the publish succeeded. Rewrite every
internal link to a moved slug (other sports, `classic/*`) before publishing. `push.py --list` prints every
slug in the project; save it to `known-slugs.txt` to refresh the snapshot.

After publishing, tell the user which pages were created or updated, what
changed compared to the old pages, and what could not be verified.
