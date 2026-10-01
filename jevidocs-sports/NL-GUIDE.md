# Dutch translation guide: jevidocs `au` project

The `au` project documents Dutch sports, their federations and AllUnited Classic
for AllUnited staff (developers, support, sales, product). English is the source
and always leads. You write the Dutch version of pages that already exist in
English. Translate faithfully: add nothing, drop nothing, don't restructure,
don't "fix" facts, don't update numbers. Never edit the English files.

## Files
- Dutch page = English file name with `.nl.md` (`tennis__guides.nl.md`), next to it.

## Voice
- Plain, direct Dutch as a Dutch colleague would write it. Address the reader
  with **je/jij**. Short sentences. No word-for-word English.
- **No mixed language.** A sentence is Dutch. Use the Dutch word a Dutch club
  volunteer or developer uses (vereniging, bond, lid, contributie, bestuur,
  penningmeester, wedstrijdsecretaris, scheidsrechter, competitie, seizoen,
  wedstrijddag, accommodatie, vrijwilliger, ledenadministratie, incasso).
- The English source glosses Dutch terms: "the treasurer (*penningmeester*)",
  "match fee (*wedstrijdgeld*)". In Dutch, use the Dutch term directly and
  **drop the gloss**: "de penningmeester", "het wedstrijdgeld". Don't italicise
  ordinary Dutch words any more. Keep italics only where they add emphasis in
  the source, or for a genuinely foreign term (an English rules term that Dutch
  players also use, e.g. *tie-break*, *try*, *scrum*, *line-out*).
- Where the source explains an English sports term that Dutch players use in
  English (rugby, ultimate), keep that term and explain it in Dutch.
- Compounds are one word or hyphenated, never split: "ledenadministratie",
  "KNLTB-lidmaatschap", "API-koppeling", "Classic-scherm".
- Numbers: Dutch style in prose (€ 27,50 → write `€27,50`, `1.200 leden`,
  `2,5 uur`). Dates: "1 januari 2026", seasons "2026–2027". Keep numbers
  themselves identical.

## Keep unchanged
- Code fences and inline `code` (paths, URLs, table names, SQL, identifiers,
  env vars, API endpoints). Don't translate comments in code either.
- **Mermaid diagrams are content, not code:** translate the human-readable
  labels inside ` ```mermaid ` blocks, keep the syntax, node ids, `block-beta`,
  `columns`, arrows and styling exactly. Keep official codes/letters in labels.
- Names: AllUnited, Classic, federation names and abbreviations (KNLTB, KNHB,
  Nevobo, KNZB, KNGU, KNHS, Sportvisserij Nederland, Rugby Nederland, NFB,
  NOC*NSF...), product names (MijnKNLTB, Sportlink, LISA, Foys, DWF, Socie,
  KNLTB.Club, Mollie, ...), official codes, class names, positions, rule
  numbers, regulation names (Reglement C, Competitiereglement).
- Titles of source documents on Sources pages (they're often already Dutch);
  translate the surrounding prose and the notes after each source.
- Component tag and attribute names (`<Callout type="info">`, `<Card href>`,
  `<Tabs items>`/`<Tab value>`, `<Steps>`, `<Step>`, `<Accordions>`,
  `<Accordion title>`). Translate human text in attribute values: Callout
  `title`, Card `title`/`description`, Accordion `title`. For Tabs, translate
  `items` and every matching `value` identically (they must keep matching),
  unless they're names (Indoor/Beach may become Zaal/Beach; KNLTB stays).
- Classic UI labels: if the English quotes a Dutch original label (italic or in
  quotes), use that Dutch label. Otherwise translate naturally.

## Front matter
- Translate `title` and `description`. Quote the value with double quotes if it
  contains `: ` or starts with a quote. Keep every other key exactly
  (`position`, `icon`, `root`, `section`, `# unpublished`).

## Links
- Internal links `/p/au/<slug>` become `/p/au/nl/<slug>`; `/p/au` becomes
  `/p/au/nl`. Markdown links and `href="..."` in components alike.
- **Keep `#anchors` exactly as in the English**
  (`/p/au/nl/tennis/rules#scoring`). They are remapped to the Dutch headings
  automatically afterwards. Don't translate or remove them.
- External links stay unchanged.

## Standard menu titles (use exactly)
| English | Dutch |
|---|---|
| Overview (home) | Overzicht |
| The sport | De sport |
| How it's played | Zo werkt het spel |
| Equipment | Uitrusting |
| Variants and disciplines | Varianten en disciplines |
| Glossary | Begrippenlijst |
| Playing | Spelen |
| Getting started | Beginnen |
| Levels, ratings and age categories | Niveaus, ratings en leeftijdscategorieën (adapt to the sport's title, same pattern) |
| Training and coaching | Training en coaching |
| Competition | Competitie |
| Structure | Opbouw |
| Match day | Wedstrijddag |
| Officials | Officials |
| Discipline and appeals | Tucht en beroep |
| Tournaments and events | Toernooien en evenementen |
| Organisation | Organisatie |
| Federation and regions | Bond en regio's |
| Clubs and facilities | Verenigingen en accommodaties |
| Memberships and fees | Lidmaatschappen en contributie |
| A club's year | Het verenigingsjaar |
| Volunteers and roles | Vrijwilligers en functies |
| Club and federation | Vereniging en bond |
| Guides | Handleidingen |
| Organising a home match day | Een thuiswedstrijddag organiseren |
| Organising a tournament | Een toernooi organiseren |
| Welcoming new members | Nieuwe leden verwelkomen |
| Planning the season | Het seizoen plannen |
| Running club finances | De verenigingsfinanciën beheren |
| Software | Software |
| Products in use | Gebruikte producten |
| AllUnited and Classic | AllUnited en Classic |
| <Federation> links | <Federation>-koppelingen (KNLTB-koppelingen) |
| Sources | Bronnen |
| Other sports | Andere sporten |

Sport names: Tennis, padel en pickleball · Hockey · Volleybal · Rugby ·
Turnen en gymnastiek → use **Gymnastiek** for "Gymnastics" · Sportvisserij
("Angling") · Paardensport ("Equestrian") · Ultimate frisbee · Zwemmen ·
Waterpolo · Atletiek · Schaatsen · Boogschieten · Cricket · IJshockey · Boules
(jeu de boules) · Classic stays Classic.

## General glossary
| English | Dutch |
|---|---|
| federation | bond |
| club | vereniging (or club where the source's context is informal/commercial) |
| member / membership | lid / lidmaatschap |
| (membership) fee, contribution | contributie |
| board / daily board | bestuur / dagelijks bestuur |
| general meeting (ALV) | algemene ledenvergadering (ALV) |
| member administrator / administration | ledenadministrateur / ledenadministratie |
| match secretary | wedstrijdsecretaris |
| treasurer / secretary / chair | penningmeester / secretaris / voorzitter |
| volunteer | vrijwilliger |
| match / game | wedstrijd |
| league / division | competitie / klasse, divisie (use the federation's own word) |
| season | seizoen |
| referee / umpire | scheidsrechter (also for hockey umpires) |
| team sheet / match form | wedstrijdformulier (DWF: digitaal wedstrijdformulier) |
| promotion / relegation | promotie / degradatie |
| facility / venue | accommodatie |
| court / pitch / field | baan / veld |
| booking (a court) | baanreservering, reserveren |
| direct debit | incasso (automatische incasso) |
| invoice | factuur |
| payment | betaling |
| screen (in Classic) | scherm |
| setting | instelling |
| feature | functie, functionaliteit |
| import / export (data) | import / export |
| link (integration) | koppeling |
| customer | klant |
| user | gebruiker |
| sign in | inloggen |
| worked example | uitgewerkt voorbeeld |
| checklist | checklist |
| common mistakes | veelgemaakte fouten |
| who does what | wie doet wat |
| not verified | niet geverifieerd |

## Done checklist (per page, before you move on)
1. Same headings in the same order and count, same tables (same rows/columns),
   same code blocks, same components. Heading order matters: anchors are
   remapped by position.
2. Every `/p/au/...` link is `/p/au/nl/...`; anchors unchanged.
3. Front matter valid; title from the menu table where it applies.
4. No English sentence outside code, names and quoted English terms.

## Terms decided by earlier batches (use the same)
cart → winkelwagen · checkout → afrekenen · slot → slot · hold time → vasthoudtijd ·
time of day → dagdeel · court group → banengroep · guest (booking) → introducé ·
release → vrijgeven · no-show → no-show · ledger account → grootboekrekening ·
reconciled → afgeletterd · discount code → kortingscode · gift card → cadeaubon ·
strip card → strippenkaart · order / order line → bestelling / bestelregel ·
refund → terugbetaling · credit invoice → creditfactuur ·
eligibility → speelgerechtigheid · exemption / dispensation → vrijstelling / dispensatie ·
target date → peildatum · suspension → schorsing · pool → poule ·
round robin → halve competitie · line-up → opstelling · squad → selectie ·
team manager → teammanager · postpone / reschedule / cancel → uitstellen / verplaatsen / afgelasten ·
referee assignment → aanstelling (assigner → aanwijzer) · ranking → ranglijst / stand ·
head-to-head → onderling resultaat · score difference → saldo ·
Quoted English strings from code or error messages stay English.
time period → tijdvak · booking tool → reserveringstool · court terminal → afhangbord ·
planning board → planbord · first-available → eerst-beschikbaar · set-up (screen) → inrichting ·
direct-debit mandate → incassomachtiging · expenses → declaraties · job → taak ·
interface key → interfacesleutel · member pass → ledenpas · VAT code → btw-code ·
Federation links → Bondskoppelingen · competitor → deelnemer · venue → locatie ·
draft → concept · reserves → wissels · starters → basisspelers · shirt number → rugnummer ·
captain → aanvoerder · queue → wachtrij · dry run → proefrun · officers → functionarissen ·
riding school → manege · kit colours → tenuekleuren · transfer (player) → overschrijving ·
cart → winkelwagen · gift card → cadeaubon (not winkelmandje/cadeaukaart) ·
Money (Classic section) → Financiën · contact (Classic record) → relatie · contact type → relatietype (Classic label *Relatietypes*) ·
contact number → relatienummer · posted → geboekt · reverse → storneren · payment type → betaalwijze ·
mass invoicing → massafacturatie · pro rata → naar rato · tiered price → staffelprijs ·
federation dues → bondsafdracht · open item → openstaande post · mandate → machtiging ·
dunning level → aanmaningsniveau · permission profile → rechtenprofiel · known limits → bekende beperkingen ·
master contact → hoofdrelatie · member portal → ledenportaal · member mutation → ledenmutatie ·
head of family → gezinshoofd · print form → printformulier · custom fields → extra velden ·
licence → licentie · registration → inschrijving · pass/card → pas ·
master contact → hoofdrelatie (module "Hoofdrelaties") · duty → dienst · duty type → dienstsoort ·
GDPR → AVG · termination reason → opzegreden · course type → cursussoort · waitlist → wachtlijst ·
attendance → presentie · package → pakket · Athletics Now → Atletiek.nu ·
Angling: angler → sportvisser · section (match) → vak · peg → plaats · draw → loting · weigh-in → weging ·
keepnet → leefnet · match director → wedstrijdleider · controller → controleur · float → dobber ·
pole → vaste stok · seat box → viskist · fishing rights → visrecht · expulsion → royement ·
Equestrian: judge → jurylid · class (on the day) → rubriek · combination → combinatie ·
warm-up arena → losrijbaan · jump-off → barrage · clear → foutloos · driving district → mendistrict (KNHS term) ·
Features → Functies · Developers (tab) → Ontwikkelaars ·
Gymnastics: judge → jurylid · all-around → meerkamp · apparatus final → toestelfinale · warm-up → inturnen ·
rotation → ronde · host club / visiting club → organiserende / bezoekende vereniging · trampoline → trampolinespringen ·
acrobatic → acrogym · rhythmic → ritmische gymnastiek · Judges and officials → Juryleden en officials ·
Hockey: umpire → scheidsrechter · abandon (match) → staken · competition management → competitieleiding ·
MoSCoW tabs Must/Should/Could stay English · Known issues (tab) → Bekende problemen · Indoor hockey → Zaalhockey ·
Unfinished → Onafgerond · Plans → Plannen · penalty corner → strafcorner · penalty stroke → strafbal ·
archer → schutter · end (archery) → schietbeurt · target face → blazoen ·
Rugby: core squad → vaste kern · referee officer → functionaris scheidsrechterzaken · touch judge → grensrechter · supply duty → leverplicht ·
Swimming: meet → wedstrijd · event → programmanummer · heat → serie · entry time → inschrijftijd · qualifying time → limiettijd · team leader → ploegleider · artistic swimming → synchroonzwemmen · diving → schoonspringen ·
Tennis: competition leader → competitieleider (CL) · tournament director → toernooileider (TL) · chair umpire → stoelscheidsrechter · line umpire → lijnrechter · referee → hoofdscheidsrechter · substitutes → invallers ·
Tennis: singles/doubles → enkel/dubbel · rubber (match within a team match) → partij · booking a court → afhangen · clay → gravel · substitute → invaller ·
Ultimate: spirit score → spiritscore · indoor/outdoor → zaal/veld · forfeit → reglementaire nederlaag · bracket → knock-outschema · pull, cap, Swiss draw, HAT stay English · match tie-break → match-tiebreak ·
Volleyball: supply duty → leveringsplicht (Nevobo) · scorer → teller · line judge → lijnrechter · hall duty → zaaldienst · referee coordinator → scheidsrechtercoördinator (SC) ·
