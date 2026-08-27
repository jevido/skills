---
name: awesome
description: >
  Capture, sharpen and maintain a project's AWESOME.md — the single living backlog document
  in the planning repo. Use when the user has an idea, wants to flesh out a rough segment,
  or wants to see what is queued. Replaces the old per-file idea capture.
  Invoked with /awesome [mode] <text>.
---

# Awesome Skill

Maintains **one document per project**: `/home/jevido/Projects/planning/<project>/AWESOME.md`.

That document is a **queue, not a record**. An idea enters here, leaves when `/planning` turns its segment into a phase, and reappears as a capability in `SUMMARY.md` once `/work` ships it. Nothing is ever archived inside AWESOME.md — the three documents divide the timeline between them:

| Document | Holds | Written by |
|---|---|---|
| `AWESOME.md` | what we have not built yet | `/awesome` |
| `phases/` | what we are building now | `/planning` |
| `SUMMARY.md` | what the project is, because we built it | `/work` |

## Constants & Project Detection

```bash
PLANNING_DIR=/home/jevido/Projects/planning
PROJECTS_ROOT=/home/jevido/Projects

# Derive project from the current working directory.
# e.g. /home/jevido/Projects/mono/apps/web  -> PROJECT=mono
#      /home/jevido/Projects/sentinel       -> PROJECT=sentinel
REL=${PWD#$PROJECTS_ROOT/}
PROJECT=${REL%%/*}

PROJECT_DIR="$PLANNING_DIR/$PROJECT"
AWESOME="$PROJECT_DIR/AWESOME.md"
SUMMARY="$PROJECT_DIR/SUMMARY.md"
```

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or `planning`, the project is ambiguous — **ask the user which project** before writing anything.

---

## The Document

```markdown
# <Project> — awesome

<One paragraph: what this project is trying to become. Present tense, plain words.>

This is the queue. A segment leaves this document the moment `/planning` turns it into a phase; what shipped is in [SUMMARY.md](SUMMARY.md).

Last checked against the code: <YYYY-MM-DD>.

## <Cornerstone>

<One line: who this cornerstone serves and what for.>

### <Segment>

<Optional paragraph — only where the segment needs a why that a bullet cannot carry.>

- <one line per idea>
- <one line per idea, carrying `path/to/file.ts:12` where the claim needs a location to be checkable>
```

### Cornerstones are the spine

A **cornerstone** is a `##` heading naming an audience and an outcome, not a technology. It is the stable layer: the same set appears in `SUMMARY.md`, so shipped work lands under the heading it was queued beneath.

Good: `## Marketing — helping clubs gain members`, `## Collaboration — helping clubs organise internally`, `## Onder de motorkap — what nobody sees and everybody feels`.

Bad: `## Database`, `## Refactors`, `## Frontend`. Those are where the work happens, not what it is for. Infrastructure belongs under a cornerstone named for the outcome it buys.

Read the existing `##` headings before inventing one. A new cornerstone is a real decision — most captures belong under an existing one.

### Segments are the unit /planning consumes

A **segment** is a `###` heading holding the bullets that become one phase. Size it that way: if a segment could not be one phase, split it.

### House rules

These are what make the document worth keeping. Follow them on every write.

- **One line per idea.** If a bullet needs a paragraph, it is a segment, not a bullet.
- **A claim about the code carries a location.** `worker.mjs runs a full vite build per job` is a rumour; `worker/scripts/worker.mjs:210 runs a full vite build per job` is checkable. Where a claim was not verified, write it as a question rather than a fact.
- **Never delete an idea for looking wrong.** An unpicked segment is a backlog entry nobody chose, not a judgement. Deleting it only means rediscovering it in six months.
- **Never hand-edit something out because it shipped.** That path is `/planning` then `/work`. A bullet that vanishes by hand leaves no trace in SUMMARY.md.
- **Write for someone who has not read the code.** Name the screen, not the component.
- **English prose.** Screen names, stored values and UI copy stay in the project's own language, quoted.
- **No hard wrapping.** One line per paragraph and per bullet.

---

## Modes

Dispatch on the first word of the argument. Anything unrecognised is **capture**.

### capture — `/awesome <thought>` (default)

1. Read `$AWESOME` in full. If it does not exist, run **init** first.
2. Decide where the thought belongs: an existing segment, a new segment under an existing cornerstone, or (rarely) a new cornerstone.
3. Rewrite the thought into house style — one line, checkable, named for the screen.
4. **Check it against the code** before writing it, in the project working directory. Three outcomes:
   - it already exists → say so, do not write it, and point at the file
   - it exists partly → capture the gap, not the whole idea
   - it does not exist → capture it, with a location if the claim needs one
5. Insert it. Print the cornerstone, segment and the line as written.
6. Commit.

Multiple thoughts in one invocation are multiple bullets. Do not merge them into one line.

### sharpen — `/awesome sharpen <segment>`

Turns a rough segment into one that `/planning` can consume without guessing. This is the mode that pays for itself.

1. Read the segment and everything it names, in the code.
2. For each bullet: verify it, add the location, and split anything carrying two ideas.
3. Add what the segment is missing — the decisions somebody has to take before a phase can be written are bullets too, phrased as decisions.
4. Where the code contradicts the bullet, rewrite the bullet to what is actually true and say so in the report.
5. Update `Last checked against the code:` to today.
6. Report: bullets in, bullets out, contradictions found, questions raised. Commit.

A segment is sharp enough when every bullet is a thing somebody could start on Monday.

### init — `/awesome init`

Creates `$AWESOME` and `$SUMMARY` for a project that has neither. Derive the cornerstones from what the project already is: read its `CLAUDE.md`, its `ROADMAP.md` and its `phases/`, and name the cornerstones after the outcomes those describe. Never ship a placeholder cornerstone list.

### migrate — `/awesome migrate`

Absorbs legacy capture into `$AWESOME`, for a project that predates this skill.

Sources, in order: a `$PROJECT_DIR/ideas/` directory (one file per idea, the old `/idea` format), and any `how-to-become-awesome*.md`.

1. Read every source file.
2. Sort each one under a cornerstone and segment; compress a whole idea file into the bullets it actually contains.
3. Drop nothing silently — anything that does not fit gets its own segment rather than being discarded.
4. Anything the code shows as already shipped goes into `SUMMARY.md`, not `AWESOME.md`.
5. `git rm` the sources in the same commit as the write, so there is one place to look afterwards. A large legacy document may instead be renamed `AWESOME-ARCHIEF.md` and linked from AWESOME.md as history — say which you did.

### status — `/awesome` with no argument

Print, without writing anything: each cornerstone, its segments, the bullet count per segment, which segments have a phase in `phases/`, and how long ago the document was checked against the code.

---

## Handing Off

- To plan a segment: `/planning <segment name>` — it reads the segment, writes the phase, and **removes the segment from AWESOME.md** in the same commit.
- To build: `/work` — it ships the tasks and grows `SUMMARY.md` when the phase completes.

Say which of the two is next when you finish a capture or a sharpen.

## Committing

```bash
cd /home/jevido/Projects/planning && git add -A && git commit -m "awesome(<project>): <what changed>"
```
