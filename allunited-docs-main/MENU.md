# The main documentation menu

**The live sidebar is the authority; this file mirrors it.** Before writing,
print it:

```sh
set -a && . ~/.config/allunited-docs.env && set +a && python3 ~/.claude/skills/allunited-docs-main/scripts/push.py --menu   # add --nl for Dutch
```

When the live menu and this file disagree, the live menu wins: someone moved
a page on purpose. Write to the live slugs, positions, sections and icons,
then update this file (the tree and the tables below) in the same session so
the next run starts true. Never move, renumber or re-section an existing page
to fit this file; restructuring the menu is a change the user asks for.

The main documentation is the `au` project's default sidebar (not a root
tab). Slugs are absolute; folders are written as their index page. `pos` is
`position`. `section` puts a top-level page under a sidebar separator; give
every top-level page its section. Snapshot of 2026-09-30:

```
AllUnited                          ← separator (section: AllUnited)
   0  Overview                     _root                 icon book
   1  The platform                 platform/             icon sparkles
   2  The apps                     apps/                 icon monitor
        1 The admin                apps/admin
        2 The club website         apps/site
        3 The console              apps/console
        4 AllUnited Bond           apps/federations
        5 Federations (module)     apps/federation/      icon package
        6 Sign-in (AllUnited ID)   apps/identities
        7 The job runner           apps/runner
   5  Roadmap                      roadmap               icon rocket
   6  What's new                   whats-new             icon zap
Features                           ← separator (section: Features, Dutch "Functies")
  10  Website                      website/              icon layout
  11  Members                      members/              icon home
        4 Federations and memberships   members/federations   icon folder (the sports overview)
  12  Matches and duties           duties/               icon check
  13  Invoicing and payments       invoicing/            icon database
  14  Booking                      booking/              icon settings
  15  Communication                communication/        icon text
Plans                              ← separator (section: Plans, Dutch "Plannen")
  25  Introduction                 plans                 icon book
  26  Media library                media-library         icon folder
  27  Helpdesk                     helpdesk/             icon hash
  28  Other projects               other-projects        icon pen
  29  Open questions               open-questions        icon info
Under the hood                     ← separator (section: Under the hood, Dutch "Onder de motorkap")
  30  Introduction                 developers            icon code
  31  Codebases                    codebases             icon github
  32  Architecture                 architecture          icon layout
  33  Sign-in and API access       sign-in               icon check
  34  APIs and feeds               apis                  icon terminal
  35  Integrations                 integrations          icon external
  36  Hosting and environments     hosting               icon database
  37  Decisions                    decisions             icon pen
```

Root tabs (Classic, every sport, Other sports) share position numbers but
live in their own tabs; `--menu` lists them apart. They are not this skill's.

A new top-level page takes a free position inside its section's range
(AllUnited 0–9, Features 10–24, Plans 25–29, Under the hood 30–39). A new
child takes the next position after its siblings.

**Modules and apps are two views of the same platform.** A module is *what*
a club can do (website, duties, members); an app is *where* someone does it
(the admin, the club site, the console). The apps folder explains each app;
module pages link to the app where each task happens, and app pages link to
the module pages instead of repeating them. Federations is a module placed
inside The apps, beside AllUnited Bond, with the same need / now / roadmap
parts as every other module.

## Every module: What clubs need, In the platform, On the roadmap

Real and ideal never share a page. Each module (and `platform/`) has the same
three parts:

```
<Module>                       index: the module on one screen
├─ What clubs need             <m>/need           one page
├─ In the platform             <m>/now/           folder: only Live, Pilot, Built
│  └─ one page per capability  <m>/now/<x>
└─ On the roadmap              <m>/roadmap/         folder: only Idea
   └─ one page per plan        <m>/roadmap/<x>
```

| Slug | pos | Title | What the page must contain |
|---|---|---|---|
| `<m>` | see below | Module name | Index. Two paragraphs: what the module is for and for whom, and in which app(s) it lives. **At a glance**: a table *In the platform* vs *On the roadmap*, each item with its status word and a link. **Classic → new**: table Classic feature → where it is now (link to a `now/` page), where it will be (link to a `roadmap/` page) or "stays in Classic for now". Cards to What clubs need, In the platform, On the roadmap. `icon`, `section: AllUnited`. |
| `<m>/need` | 1 | What clubs need (Federations: What federations need) | The problem for the club or federation in their own situation (a volunteer, a Saturday, a season), what Classic does today and where it hurts (link the Classic pages), what good looks like, which principles shape the module and how. No features here. |
| `<m>/now` | 2 | In the platform | Folder index. One status line per capability (Live / Pilot / Built, where it runs: which clubs). Who uses it today, in which app. Cards to the pages. **When nothing exists yet**, this is a single page (no children) that says so plainly, says what clubs use instead today (Classic, with links) and links On the roadmap. |
| `<m>/now/<x>` | 1+ | Capability | Only what exists, as it works today. Status callout, no date. Where it lives (app and screen). How it works (model, rules and their reason, a mermaid picture where it helps), a guide for the volunteer who does it (`<Steps>`, what gets refused and why, common mistakes), known limits. Ends with **Next**: one line and a link to the `roadmap/` page that extends it, if any. Never describes planned behaviour except in that line. |
| `<m>/roadmap` | 3 | On the roadmap | Folder index. Table idea → why it matters → what it depends on. Which ideas unlock others. Open questions. No status column, no order in time. |
| `<m>/roadmap/<x>` | 1+ | Plan | Status callout "Status: Idea", no date, no progress report. The need (who asked, which clubs or federations, what they do now), what it would do, how it would fit the model, what it depends on, open questions, and what exists today towards it (link `now/`). Written as intent: "will", "would", never "does". |

When a plan ships, its page moves from `roadmap/` to `now/` (new slug; delete
the old one after confirmation) and the index tables change in the same
publish.

## Home and platform

| Slug | pos | Title | What the page must contain |
|---|---|---|---|
| *(home, `_root`)* | 0 | Overview | `icon: book`. What AllUnited is building in three paragraphs: one platform for Dutch clubs and federations, simple enough that volunteers run it without support, replacing Classic step by step. A table of every module: one line, *in the platform* in a few words, *on the roadmap* in a few words. A small picture of the apps and who uses each. Cards to The apps, every module, the Roadmap, For developers, Classic and Sports. "Start here" `<Tabs items="Support,Sales,Developers">`, four links each. |
| `platform` | 1 | The platform | Index as for a module; covers what every module shares. `icon: sparkles`. |
| `platform/need` | 1 | What clubs need | What we want to achieve and why: from complexity to simplicity, support questions as a design failure, growing by addition, one view of each customer, why now. The principles, each with what it means in practice and an example from a module. Who it is for: the people (member administrator, treasurer, chair, website editor, referee coordinator, member, parent, federation staff, AllUnited support) and which modules and apps each uses. |
| `platform/now` | 2 | In the platform | Folder. |
| `platform/now/signing-in` | 1 | Signing in and accounts | One account for everything, invitations, login-less links for members, a person in several clubs. |
| `platform/now/new-club` | 2 | Starting a club | The new-club wizard, the federation step, bulk creation, ownership transfer. |
| `platform/now/roles` | 3 | Roles and permissions | Seeded roles, the permission catalogue, custom roles, staff roles kept apart, role × module table. |
| `platform/now/languages` | 4 | English and Dutch | What is translated, how a club and a user pick the language. |
| `platform/roadmap` | 3 | On the roadmap | Folder. |
| `platform/roadmap/communities` | 1 | Clubs, federations and districts in one model | A community hierarchy (federation → district → club) and why the federation sits in the core. |
| `platform/roadmap/modules` | 2 | Switching modules on and off | Per-club modules, dependencies, dated switch-off, data retention, what gets billed. |
| `platform/roadmap/customer-view` | 3 | One view of every customer | Usage and health per club measurable by default. |
| `platform/glossary` | 4 | Glossary | Every platform term in English: term, meaning, module, the Classic term it replaces where different. No Dutch; the Dutch page has the Dutch terms. |
| `roadmap` | 5 | Roadmap | `section: AllUnited`, `icon: rocket`. Across modules: every idea, grouped by module, what it depends on and which ideas unlock others. No now/next/later, no dates. |
| `whats-new` | 6 | What's new | `section: AllUnited`, `icon: zap`. Month by month, newest first: what shipped, what entered a pilot, which decisions were taken. |

## The apps

One page per app in the `clubs` monorepo, written for everyone (support,
sales, product), not only developers. The technical side of each app is on
`codebases`. Check the list against `clubs/apps/` and
`clubs/services/` before writing; an app added there gets a page here.

| Slug | pos | Title | What the page must contain |
|---|---|---|---|
| `apps` | 2 | The apps | `icon: monitor`, `section: AllUnited`. Folder index: every app in one picture (mermaid: people → apps → the shared sign-in and data), a table app → who uses it → address → what they do there, Cards. |
| `apps/admin` | 1 | The admin | Where a club's volunteers work. Who signs in, how to get there, the main screens and which module each belongs to (link the modules' `now/` pages), what a role sees, "what's new" and feedback. |
| `apps/site` | 2 | The club website | The public site every club gets: what visitors and members see, how it is built from the admin's content, addresses (`<slug>.club.allunited.dev`, own domain), login-less duty pages, feeds. |
| `apps/console` | 3 | The console | AllUnited staff's screens: clubs, accounts, roles and staff, background work, own domains, website transfer. Who may use it and what staff do there for support. |
| `apps/federations` | 4 | AllUnited Bond | The federations app: who uses it (federation staff, AllUnited staff), what they do there today, its roles, the federation API. Links the Federations module. |
| `apps/federation` | 5 | Federations | The Federations module (see The modules). |
| `apps/identities` | 6 | Sign-in (AllUnited ID) | The one account and sign-in every app uses: signing in, invitations, what a person with several clubs sees, where to go when sign-in fails. Links `platform/now/signing-in` and `sign-in`. |
| `apps/runner` | 7 | The job runner | What happens behind the scenes, in plain words: building club sites, the federation sync, website transfer, mails, the monthly digest; how long things take and what a volunteer or support sees when a job fails. |

Every app page follows the same order: **what it is** · **who uses it** ·
**where to find it** · **what you do there** (links to module pages) ·
**what's coming** (links to `roadmap/` pages, clearly marked as planned).

## The modules

Positions and sections as in the tree above. Every `federation/...` slug
below is written in full as `apps/federation/...`.

Order, slug, icon (must be a key the site draws, see below) and the pages
each module starts with. Check each against the code before writing: a
`now/` page needs evidence in `clubs`; move it to `roadmap/` if the evidence
is missing, and add `now/` pages for anything built that is missing here.

### 10 · Website: `website`, icon `layout`

What clubs need: about 500 clubs on Classic websites, volunteers who must keep a site up
to date, privacy and no cookie banners.

- `now/`: `pages-and-blocks` Pages and blocks · `news` News · `calendar`
  Calendar · `photos` Photos, files and consent · `teams` Team pages ·
  `sponsors` Sponsors · `appearance` Appearance and navigation · `publishing`
  Preview and publish · `search-and-feeds` Search, feeds and
  sitemap · `statistics` Statistics · `transfer` Moving an old website
- `roadmap/`: `member-area` Member login and members-only content ·
  `forms` Registration forms · `writing-assistant` Writing assistant ·
  `social` Posting to social media · `rollout` Moving every Classic site ·
  `own-domains` Own domains · `wastebasket` Wastebasket and restore

### 11 · Members: `members`, icon `home`

What clubs need: the member administration is the heart of a club and of Classic; one
record per person, memberships that drive fees, privacy.

- `now/`: `members-and-memberships` Members and memberships ·
  `invitations` Inviting volunteers · `privacy` Privacy requests (GDPR export)
- `roadmap/`: `contacts` Contacts without an account · `households` Households,
  parents and children · `membership-types` Membership types and periods ·
  `joining-and-leaving` Joining and leaving · `self-service` Members keep
  their own details · `import` Importing members from Classic ·
  `membership-card` The digital membership card

### 12 · Matches and duties: `duties`, icon `check`

What clubs need: every weekend a club needs referees, scorers and bar staff; federation
data can plan most of it; volunteers claim duties without an account.

- `now/`: `federation-data` Matches from the federation (Nevobo) ·
  `assigning` Assigning duties · `claiming` Claiming a duty ·
  `referee-roster` Referees and the referee coordinator · `team-duties` Duties
  for a whole team
- `roadmap/`: `other-duties` Bar and other duties · `more-federations` Matches
  from other federations · `licences` Licence checks · `levels` Referees
  appointed by the federation (rugby) · `volunteer-points` Volunteer points ·
  `write-back` Duties in Classic and the ClubApp

### 13 · Invoicing and payments: `invoicing`, icon `database`

What clubs need: without money coming in, a platform has no value to a club; the
treasurer's year; SEPA, iDEAL, dunning.

- `now`: single page (nothing built yet; Classic's Money pages).
- `roadmap/`: `fees` Fees and discounts · `invoice-runs` Invoice runs ·
  `invoices` Invoices and credit notes · `online-payments` Online payments ·
  `direct-debit` Direct debit and mandates · `receivables` Receivables,
  reminders and dunning · `federation-dues` Federation dues ·
  `bookkeeping` Bookkeeping export

### apps · 5 · Federations: `apps/federation`, icon `package`

What clubs need: a federation needs its clubs, members and competitions in one place;
federation data is what makes club work automatic.

- `now/`: `bond` What federations do in AllUnited Bond · `federation-api`
  Federation and sport lists · `club-directory` Finding a club by its
  federation
- `roadmap/`: `districts` Districts and regions · `registration` Registering
  clubs and members · `member-register` The member register ·
  `federation-sync` Exchanging data with federations · `competition`
  Running a competition · `match-form` The digital match form ·
  `referee-assignment` Assigning referees as a federation

### 14 · Booking: `booking`, icon `settings`

What clubs need: tennis and padel clubs live on court bookings; the court terminal,
lighting and access, Meet & Play.

- `now`: single page. Nothing in the new platform yet; clubs book courts
  with Classic's booking tool (link `classic/booking`). The Classic tool is
  too intertwined with Classic to migrate, so booking here will be built new.
  Only when that work starts does this become a folder.
- `roadmap/`: `courts` Courts and booking rules · `terminal` The court
  terminal · `lighting-and-access` Lighting and access · `meet-and-play`
  KNLTB Meet & Play · `waitlist` Waitlist and kiosk

### 15 · Communication: `communication`, icon `text`

What clubs need: members are reached through the app and mail more than the website;
teams, groups and roles need their own channels.

- `now/`: `emails` Emails the platform sends (invitations, duty mails,
  monthly digest) · `subscriptions` Calendar and news subscriptions
- `roadmap/`: `team-messages` Messages to teams and groups · `dynamic-groups`
  Groups that follow the member data · `role-mailboxes` Mailboxes per role ·
  `newsletters` Newsletters · `clubapp` The ClubApp

Icons the site draws (`apps/site/src/lib/Icon.svelte`): search, file,
folder, hash, text, info, book, database, bot, layout, zap, pen, code,
sparkles, terminal, rocket, home, settings, package, check, monitor. Any
other name shows no icon.

## Under the hood

| Slug | pos | Title | What the page must contain |
|---|---|---|---|
| `developers` | 30 | Introduction | `section: Under the hood`, `icon: code`. The platform from the inside in one diagram; Cards to the pages below. The developer pages are top-level slugs in this section, not children of `developers`. |
| `codebases` | 31 | Codebases | The `clubs` monorepo: every app, service and shared package, what each holds, which modules it serves, the stack. The only page that names repositories. |
| `architecture` | 32 | Architecture | One sign-in, multi-tenant data, the job runner, static club sites, how modules stay apart. |
| `sign-in` | 33 | Sign-in and API access | OIDC clients, scopes, PAR, machine-to-machine tokens, API resources. |
| `apis` | 34 | APIs and feeds | Every API and public output, conventions, examples. |
| `integrations` | 35 | Integrations | Nevobo, Classic API, Resend, S3 storage, GitHub feedback, the language model for website transfer; direction, data, status. |
| `hosting` | 36 | Hosting and environments | Coolify, environments and branches, domains, databases and migrations, backups. |
| `decisions` | 37 | Decisions | Index of the decision records: number, title, status, one line. |

Every page ends with its own short `## Sources` list.

## Plans

| Slug | pos | Title | What the page must contain |
|---|---|---|---|
| `plans` | 25 | Introduction | `section: Plans`, `icon: book`. What the Plans pages hold: work that spans modules and is not yet one module's roadmap page. Cards. |
| `media-library` | 26 | Media library | `icon: folder`. The idea, written as a roadmap page would be. Children 0–7 describe the library, `integrations` (8) holds `community`, `website` and `teams` (how the apps use it), `architecture` is 9. |
| `helpdesk` | 27 | Helpdesk | `icon: hash`. The idea, shaped like the media library. Children: `introduction` 0, `finding-your-way` 1, `asking` 2, `tickets` 3, `boxes` 4, `forwarding` 5, `privacy` 6, `console` 7 (holds `inbox`, `tiers`, `entering`: AllUnited's side), `integrations` 8 (holds `admin`, `website`, `storage`, `mail`), `architecture` 9. |
| `other-projects` | 28 | Other projects | `icon: pen`. Ideas outside the modules. |
| `open-questions` | 29 | Open questions | `icon: info`. Questions still open, each with the role that decides. |

The status rules apply here too: these are ideas, with no dates and no
progress reports.

## History

The earlier `features`, `unfinished` and top-level `sources` pages were
deleted; their content lives in the modules' `now/` and `roadmap/` pages and
in each page's own `## Sources`. `architecture` and `hosting` are now
developer pages. Links to moved slugs, including from `classic/*` and sport
pages, were rewritten.
