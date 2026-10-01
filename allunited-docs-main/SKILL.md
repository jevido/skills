---
name: allunited-docs-main
description: Write, restructure or deepen the main documentation of the AllUnited Docs `au` project (docs.allunited.dev/p/au) — the pages about the new AllUnited platform that replaces Classic: what we want to achieve, its principles, communities and federations, every app in the clubs monorepo (admin, club website, console, AllUnited Bond, sign-in, job runner), and every module (website, members, matches and duties, invoicing and payments, federations, booking, communication), each split into what clubs need, what is in the platform and what is on the roadmap, the roadmap and what's new, and how it is built. Use when asked to write or update "the main docs", "the AllUnited docs", the home page, the platform, app or module pages, the roadmap or the developer pages on AllUnited Docs. Not for sport pages (use allunited-docs-sports) and not for the Classic tab.
---

# Writing the main AllUnited documentation

The `au` project on AllUnited Docs (docs.allunited.dev) has three parts:

- the **main documentation**: the home page and the top-level folders about
  the **new AllUnited platform** (this skill);
- the **Classic** tab (`classic/*`): the PHP platform clubs use today;
- one tab per **sport** (skill `allunited-docs-sports`).

The main documentation answers four questions for anyone at AllUnited
(support, sales, product, developers) and, later, for club and federation
volunteers:

1. **What are we building, and why?** The vision, the principles, and the
   people it is for.
2. **What can it do?** Every module: what it is for, how it works, how a
   volunteer uses it, and how far along it is.
3. **Where is it going?** Each module's roadmap, and the roadmap across
   modules.
4. **How is it built?** Codebases, sign-in, APIs, integrations, hosting,
   decisions.

It must represent **the whole platform we are building**, not just the part
that runs today. The website CMS is live at pilot clubs; contacts,
memberships, invoicing and federations are the core that is still being
built. Both belong here, each with an honest status.

## Structure

**The live menu comes first, every time.** Before planning or writing any
page, print the current sidebar:

```sh
set -a && . ~/.config/allunited-docs.env && set +a && python3 ~/.claude/skills/allunited-docs-main/scripts/push.py --menu   # --nl for Dutch
```

[MENU.md](MENU.md) mirrors it and says what each page must contain. Where the
two disagree on slug, position, section, icon or parent, **the live menu
wins**: write into the structure as it is, and update MENU.md (tree and
tables) in the same session. Do not move, renumber or re-section existing
pages to match MENU.md or your own idea of a better menu; a restructure is
the user's call. A new page goes where the live menu's pattern puts it
(same section, next free position among its siblings, the same
need / now / roadmap shape), and a `--dry` run must show it landing there.

The shape copies the sport tabs. Every module is its **own top-level
folder** (Website, Members, Matches and duties, Invoicing and payments,
Federations, Booking, Communication), and every module has the **same three
parts**, so real and ideal never mix:

- **What clubs need** (`need`; "What federations need" in Federations): the
  problem for clubs and federations, and what good looks like;
- **In the platform** (`now/`): only what exists (Live, Pilot, Built);
- **On the roadmap** (`roadmap/`): only what doesn't (Idea).

A reader who knows one module knows where to look in the next. The modules
sit under the **Features** separator, except Federations, which lives inside
The apps (`apps/federation/`). Next to the modules, **The apps** explains every app in the `clubs` monorepo (the admin,
the club website, the console, AllUnited Bond, sign-in, the job runner): what
it is, who uses it, where to find it, what you do there. Modules say *what*
a club can do; apps say *where*.

## Status: either we have it, or it is an idea

The docs carry **no concept of time**. A thing is in the platform or it is an
idea; there is no "planned", "in development", "being built", "next", "later",
"soon" or "coming", and no as-of dates. Tracking progress in the docs costs
upkeep nobody has time for; progress lives in the planning repo and the
changelog. Every module index and every page describing a capability opens
with a status callout, using exactly one of these words:

| Status | Means | Evidence needed |
|---|---|---|
| **Live** | Customers use it in production | Deployed, in use by named clubs |
| **Pilot** | Running at a few clubs to learn | Deployed, the pilot clubs are known |
| **Built** | Works, not yet used by clubs | Code on the main branch, tested |
| **Idea** | Anything not in the platform | Everything else: a wish, a decision, a plan, code on a branch |

```
<Callout type="info" title="Status: Pilot">
Running at two volleyball clubs. Team duties and the bulk import work; a
bar-duty generator is on the roadmap.
</Callout>
```

No month or year in the callout. Dates appear only as history that never goes
stale ("went live on 25 September 2026") and in Sources. **The `clubs` code on
the main branch is the evidence for Built, Pilot and Live.** A roadmap page
never reports progress (branches, phases, tasks done, reviews); it says what
the idea would do and what it depends on. A `now/` page points at an idea as
"on the roadmap", with a link. Never present an idea as a built feature. When
wiki and code disagree, the code wins.

## Language

- **English only.** No Dutch words in English pages: no "(*penningmeester*)"
  glosses, no Dutch terms in brackets, no Dutch ↔ English tables. Write
  "treasurer", "direct debit", "federation". The Dutch wording lives in the
  Dutch translation of the same page (`.nl.md`), never in the English one.
  Exceptions: proper names (Nevobo, KNLTB, AllUnited Bond) and quoted UI
  labels or URLs exactly as they appear (`/nieuws`).
- **The glossary is English**: term, meaning, where it is used. Its Dutch
  translation page gives the Dutch terms.
- **Every page exists twice**: English first, Dutch as a faithful translation
  in natural Dutch, published together. Follow
  [../allunited-docs-sports/NL-GUIDE.md](../allunited-docs-sports/NL-GUIDE.md)
  for the Dutch voice, links (`/p/au/nl/...`), front matter and its general
  glossary, plus [NL-MAIN.md](NL-MAIN.md) for this part's menu titles and
  terms. Because the English has no Dutch glosses, the translator picks the
  Dutch word volunteers use (ledenadministrateur, incasso, bond).
- **Names.** The product is **AllUnited**; write "the new platform" only
  where it must be told apart from Classic. Its code lives in one monorepo,
  `clubs`, named only on `codebases`. **Never mention Mono, Easy,
  is4c, the Hub as a planned backend, or that the platform had an earlier
  attempt**: not as history, not as a working name, not as "previously". The
  company's other products (Classic, the chatbots) are named as they are.
- Use the platform's own terms consistently, as defined on
  `platform/glossary`: community, member, membership, contact, federation,
  district, module, role, permission, duty, match, invoice run, open item,
  mandate, booking. Define each on first use on a page, or link the glossary.
- Plain words for a volunteer: "the treasurer sends this season's invoices in
  one run", not "batch invoice generation is supported".

## What a good page does

- **Explain before you use**, with one worked example per mechanism: a
  membership that renews in September, an invoice run from open item to paid,
  a duty claimed by a team, a court booked and released.
- **Show the model as a picture.** A mermaid diagram for hierarchies
  (federation → district → club), lifecycles (draft → final → sent → paid)
  and flows. Every `style`/`classDef` with a `fill` also sets `color`
  (`#0a0a0a` on light fills) so it reads in dark mode; render light and dark
  before publishing (theme in `~/Projects/docs/apps/site/src/lib/enhance.ts`,
  `diagramTheme`).
- **Rules and invariants in plain sentences**, with the reason: "A member
  holds at most one membership per period, so an invoice run never bills a
  person twice."
- **The volunteer's view first.** Guides are how-tos for one role (member
  administrator, treasurer, website editor, referee coordinator, federation
  staff): `<Steps>`, who does what, what the screen refuses and why, common
  mistakes.
- **Real and ideal apart.** A `now/` page describes only what works now,
  in the present tense; a `roadmap/` page only intent ("will", "would"). A
  `now/` page may end with one **Next** line linking its plan. Never blend
  the two in one paragraph.
- **No migration section.** There is no "Moving from Classic" section or
  page. Classic appears only where it explains a module: in its need page
  (what Classic does and where it hurts) and in the module index's Classic →
  new table.
- **Classic next to new.** Every module index maps Classic features to a
  `now/` page, a `roadmap/` page or "stays in Classic for now". Link the
  Classic pages (`/p/au/classic/...`) instead of repeating them.
- **Self-contained.** The reader never needs the wiki or a repository to
  understand the page; link them in Sources only. Never cite the Mono or
  Easy collections or their documents as a source, not even by title.
- Depth through structure: tables, diagrams, `<Steps>`, cross-links. Folder
  indexes 300–800 words, content pages 500–2,000.
- Refer to people in the wiki by role, never by name. Fictional persona names
  from the wiki (the volunteer persona, the treasurer persona) may be used as
  personas.
- Never copy credentials, tokens, phone numbers or customer contact details.

## Sources and research

In this order:

1. **The current pages.** Read every page you replace (`read_page` via the
   `mcp__allunited-docs__*` tools, or `push.py --list`). Facts on them must
   survive in the new structure or be corrected on purpose; say where each
   old page's content went.
2. **The code**, for what exists. The platform is the `clubs` monorepo:
   - `~/Projects/clubs`: every app and service of the platform: the admin
     (website, members, matches and duties), the club site, sign-in
     (`apps/identities`), the staff console, the federations app (AllUnited
     Bond) and the job runner. Decision records in `docs/decisions/`, glossary
     in `docs/decisions/0028-glossary.md`, changelog in
     `apps/admin/changelog/`.
   - `~/Projects/planning/clubs/`: current phase and tasks.
   - `~/Projects/bookingstool` is **part of Classic** (the Classic booking
     tool, documented under `classic/booking`), not of the new platform. It
     is too intertwined with Classic to migrate; a booking module in the new
     platform would be built from scratch. Never count it as something the
     new platform has.
   - Classic (`~/Projects/allunited-docker`, `~/Projects/dwf`): targeted greps
     only, never broad reads; prefer the Classic tab's pages.
3. **The wiki (Outline)** via `mcp__outline__*` (load with ToolSearch
   `select:mcp__outline__list_documents,mcp__outline__fetch,mcp__outline__list_collection_documents`),
   for vision, plans and priorities. Search with `limit` ≤ 10. Collections:
   - **Mono** and **Easy - POC**: an earlier attempt at a new platform
     (internal background only; never mention it or its names in the
     docs). Mine them for ideas the platform still needs: the domain model
     (community, contact, membership, module, federation, district), personas
     and roles, the invoicing and receivables requirements and glossary,
     coverage analysis, the function-by-function migration route, the
     membership card. What they planned is **not** automatically the
     platform's plan: describe it as an Idea only when it fits `clubs`
     (code, decisions, planning) or the user confirms it; otherwise leave
     it out. Never take their status boards or dates as the platform's.
   - **Functionaliteit**: module inventories (booking tool, Socie app,
     competition per federation).
   - **Project CMS**: the website: wish list, pilot plan, commercial plan.
   - **Volleybal scheidsrechters indelen**: duties pilot notes.
   - **Bonden**, **Profielen**: federation needs.
   Pages marked draft or proposal are intentions, not decisions; say so.
   Skip documents holding credentials.
4. **Public sources** only for external facts (Pay.nl, SEPA, Socie, federation
   systems), with a year.

Mark what you could not confirm. Never invent a feature, date, customer,
price or number.

## Page format

Identical to the sport pages: file name = slug with `/` → `__`
(`invoicing__roadmap__invoice-runs.md`), Dutch = same name with `.nl.md`, home
page = `_root.md`. Front matter:

```
---
title: Invoicing and payments
description: One sentence, shown under the title and in search.
position: 13
section: Features
icon: database
---
```

`section` puts a top-level page under a sidebar separator; take section,
position and icon from `--menu`. `icon` only on top-level pages and module
folders. For existing pages give only what you change;
missing fields keep their value.

Markdown: CommonMark + GFM tables, **no H1**, `##` and `###`. Components
(`<Callout>`, `<Cards>`/`<Card>`, `<Tabs>`/`<Tab>`, `<Steps>`/`<Step>`,
`<Accordions>`/`<Accordion>`) on their own lines with blank lines around
Markdown inside, exactly as in the sports skill. ` ```mermaid ` renders.
Internal links `/p/au/<slug>`; link only pages that exist or are in the same
publish. Every page ends with `## Sources`.

## Working with agents

One agent per module (or per two small modules), **at most two at a time**.
Give each this skill's path, its slugs from MENU.md, the old page texts, the
research notes relevant to it, and an output directory. Tell agents not to
spawn sub-agents and not to publish; you publish.

## Validate

```sh
cd ~/.claude/skills/allunited-docs-main/scripts/render
go build -o /tmp/audocs-render . && /tmp/audocs-render <dir> $(cat ../../known-slugs.txt) $(ls <dir> | sed -e 's/\.nl\.md$//' -e 's/\.md$//' -e 's/__/\//g')
```

No output means clean (`UNEXPANDED` = broken component, `DEAD LINK` = link to
a missing page). For Dutch pages run `scripts/nlcheck`
(`go run . -fix <en dir> <nl dir>`). Then check:

- no Dutch in English pages: read them;
  `ls <dir>/*.md | grep -v '\.nl\.md$' | xargs grep -nE '\(\*[^)]+\*\)'` catches
  italic glosses;
- no earlier-attempt names anywhere: `grep -nwE 'Mono|Easy|is4c'` must be
  empty (check hits of "easy" as an ordinary word by hand);
- no secrets or phone numbers:
  `grep -nE '(\+31|06)[ -]?[0-9]{8}|secret|api[_ ]?key|password'`;
- every module page has a status callout without a date; every page ends with Sources;
- the structure matches the live menu: in the `--dry` output every UPDATE
  keeps its live position (no front-matter `position`/`section`/`icon` on an
  existing page unless you mean to change it), and every CREATE sits in its
  siblings' section with the next free position.

## Publish

Writing needs the admin token in `~/.config/allunited-docs.env` (`token=`).
Publish yourself, without asking, after a `--dry` run shows only the pages
you meant:

```sh
cd <dir> && set -a && . ~/.config/allunited-docs.env && set +a && python3 ~/.claude/skills/allunited-docs-main/scripts/push.py . --dry
```

Then without `--dry`. Always pass the directory of pages; push.py refuses a missing directory,
unknown flags and a directory holding `SKILL.md`. Pages whose content moved
are deleted with `push.py --delete slug,nl:slug` only **after** the new pages
are live and **after the user confirms**; deleting is permanent. Rewrite every internal link
to a moved slug first, including links from `classic/*` and sport pages (grep
the slug snapshot and the pages). Refresh the snapshot afterwards:
`python3 push.py --list > ~/.claude/skills/allunited-docs-sports/known-slugs.txt`,
then run `--menu` once more and bring MENU.md's tree up to date if the
publish changed the structure.

Afterwards tell the user which pages were created, updated or are waiting to
be deleted, where each old page's content went, and what could not be
verified.
