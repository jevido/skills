# The standard sport menu

Every sport is a **root** in the jevidocs `au` project: a top-level folder whose
index page has `root: true`, so it gets its own tab in the sidebar switcher and
its own menu. Every sport has the **same menu**; only the content differs. If a
page truly doesn't apply to a sport, keep it and say in a few sentences why
(e.g. "Angling has no officials at club level; here is who enforces the rules
instead"). That is itself useful to the reader.

Slugs below are relative to the sport (`<sport>/…`, e.g.
`tennis/competition/match-day`). Folders are written as their index page
(`competition`), children under it. `pos` is the `position` front-matter value.

| Slug | pos | Title | What the page must contain |
|------|-----|-------|----------------------------|
| *(sport)* | — | Sport name | Root index. Front matter `root: true`, an `icon` (one word, e.g. `trophy`), a one-line description. The sport in three paragraphs for a newcomer, the Dutch picture in numbers (members, clubs, federation, year + source), AllUnited's relationship with the federation, and `<Cards>` to every folder. Short "start here" list for three readers: support, sales, developers. |
| `the-sport` | 1 | The sport | Folder index: what makes this sport distinct, how a game or event looks from the stands, a one-screen summary with Cards to its pages. |
| `the-sport/rules` | 1 | How it's played | Objective, playing area with dimensions (mermaid or table), team size, duration, scoring with a worked example, the rules that shape play, fouls/penalties. Sourced from official rules. |
| `the-sport/equipment` | 2 | Equipment | Every piece of equipment: personal (clothing, protection, the implement: racket/stick/bow/…), team/club equipment, facility equipment (nets, goals, lighting, scoreboards, timing, targets, boats…). For each: what it is, how it's used in play, rules and standards it must meet (sizes, approval, safety), who owns and pays for it (member, club, federation), typical cost range, maintenance and storage, what the club must track (loan, inspection, replacement). A table plus prose. |
| `the-sport/variants` | 3 | Variants and disciplines | Every variant or discipline (indoor/outdoor, beach, sevens, flag, para/G-sport, recreational forms, youth formats), how it differs, how big it is in NL. Big variants get their own extra page in this folder (pos 5+), e.g. `tennis/the-sport/padel`. |
| `the-sport/glossary` | 4 | Glossary | Table: Dutch term, English, meaning — every term a club volunteer uses, plus federation and software jargon. |
| `playing` | 2 | Playing | Folder index: the path from first try to competition, as a mermaid flow. |
| `playing/getting-started` | 1 | Getting started | How a newcomer starts: trial lessons, introduction memberships, beginner courses, what to bring, costs, finding a club. |
| `playing/levels` | 2 | Levels, ratings and age categories | Playing levels, ratings/rankings and how they are calculated (worked example), age categories with the reference date, moving up. |
| `playing/training` | 3 | Training and coaching | How training is organised at a club (groups, frequency, facility time), trainer/coach qualifications and licences, youth development, lessons by paid pros vs volunteers. |
| `competition` | 3 | Competition | Folder index: the competition landscape in one picture (mermaid pyramid/tree), Cards. |
| `competition/structure` | 1 | Structure | Season calendar, leagues/divisions/pools/tiers, regions/districts, promotion and relegation, points and tiebreakers, entry and deadlines, youth competition. |
| `competition/match-day` | 2 | Match day | A match day as `<Steps>` from both the home club's and the away team's view: before (line-ups, facility, officials), during, after (match form, results, reporting deadlines). Worked example of a filled-in result. |
| `competition/officials` | 3 | Officials | Referees/umpires/judges/scorers: roles, training, licence levels, assignment (federation vs club), obligations for clubs (quotas, fines), pay/expenses. |
| `competition/discipline` | 4 | Discipline and appeals | Cards, suspensions, tribunal, protests, appeals, fines, eligibility disputes — process and deadlines. |
| `competition/tournaments` | 5 | Tournaments and events | Tournaments, championships, cups, open events, recreational events: formats, sanctioning, entry, who organises. |
| `organisation` | 4 | Organisation | Folder index: federation → region → club diagram, Cards. |
| `organisation/federation` | 1 | Federation and regions | The federation: legal form, size, governance, what it does and charges; regions/districts and their roles; international body; other organisations (NOC\*NSF, commercial operators). |
| `organisation/clubs` | 2 | Clubs and facilities | Typical club sizes and shapes, the board and committees, facilities (owned/rented/municipal), clubhouse and bar, finances in broad terms. |
| `organisation/memberships` | 3 | Memberships and fees | Membership types table with real club prices (source, year), federation fees per member, how fees are collected, registration and cancellation rules. |
| `organisation/club-year` | 4 | A club's year | Month-by-month table of the season: registration, team formation, competition entry, season start, holidays, ALV, contribution run, end of season. |
| `organisation/volunteers` | 5 | Volunteers and roles | Every volunteer role (board, match secretary, team manager, bar, referee, field, youth, sponsoring), what each does, how duties are scheduled and enforced (points, fines). |
| `organisation/club-federation` | 6 | Club and federation | Every process between club and federation: member registration and licences, transfers, competition entry, team lists, results, discipline, VOG, certificates, insurance, invoices — direction, channel, deadline, failure modes. |
| `guides` | 5 | Guides | Folder index: what the guides are (practical how-tos that club volunteers use as their reference, written so AllUnited staff understand the work our software must support). |
| `guides/home-match-day` | 1 | Organising a home match day | Checklist-style guide: weeks before, the week of, the day, afterwards. Who does what, what to prepare, what goes wrong, what software is used at each step. |
| `guides/tournament` | 2 | Organising a tournament | From idea to aftermath: sanctioning, entry, draw/schedule, officials, facilities, catering, results, finance. |
| `guides/new-members` | 3 | Welcoming new members | From enquiry to first match: trial, registration, federation registration, kit, team placement, direct debit, onboarding. |
| `guides/season-planning` | 4 | Planning the season | Team formation, training schedule and facility allocation, competition entry, duty rosters, budget. |
| `guides/finances` | 5 | Running club finances | Contributions and invoicing, federation invoices, facility costs, sponsorship, subsidies, the treasurer's year, the ALV. |
| `guides/climbing-the-ladder` | 6 | Starting a club and climbing the ladder | Founding the club and joining the federation, licences, officials, entry level of a first team, the full promotion/relegation scheme with numbers, the fastest route to the top, shortcuts, what each level demands. Self-contained: the reader needs no external source. |
| `software` | 6 | Software | Folder index: the software landscape as a diagram (federation systems, club systems, apps, and how they connect). |
| `software/products` | 1 | Products in use | Table of every product (maker, user, purpose, mandated or chosen, cost), grouped by job; who wins and why. |
| `software/allunited` | 2 | AllUnited and Classic | What Classic does for this sport, links to `/p/au/classic/...`, federation links, usage numbers, gaps, bugs, needs, opportunities. |
| `software/<integration>` | 3+ | e.g. Hockeyweerelt, KNLTB links | Sport-specific systems or federation integrations that need their own page. Existing pages of that kind move here. |
| `sources` | 7 | Sources | All sources for the sport, grouped (federation documents, rules, club sites, wiki, Classic code), each with year. |

Every page also ends with its own short `## Sources` list.

## Sizes

Folder indexes 300–800 words. Content pages 600–2,500 words; the rules,
equipment, match day and products pages usually need the most. Aim for depth
through **structure** — tables, worked examples, diagrams, steps — not length
for its own sake. Link liberally between pages of the sport.

## Moving existing pages

Existing children of a sport (e.g. `rugby/needs`, `fishing/groot-rotterdam`,
`volleyball/clubs`) get a place in this menu: federation or software
integrations under `software/`, customer/pilot notes under `software/`, big
variants under `the-sport/`. Old slugs that are not reused are deleted after
the move (the user confirms deletions). Rewrite every internal link to the new
slugs, also in other sports and in `classic/*`.
