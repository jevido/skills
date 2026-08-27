---
name: planning
description: >
  Spar over what to build next, then plan exactly one phase of it into the planning repo at
  /home/jevido/Projects/planning. Use when the user wants to decide what comes next, scope it,
  or break it into tasks. Invoked with /planning [what to plan].
---

# Planning Skill

A **sparring session**, not a form-filler. The user brings an idea or a rough direction; you bring what the code actually says, and together you land on one phase worth building next. Then you write it down.

Two rules shape everything below:

- **One phase per invocation.** Never plan a queue of phases. Planning three phases deep means planning against a repo that will not exist by the time phase three starts — the eight phases removed from this project on 2026-08-27 were removed for exactly that.
- **Tasks reach to the end of the phase and no further.** A task that depends on a phase nobody has planned is not a task, it is a note.

## Constants & Project Detection

```bash
PLANNING_DIR=/home/jevido/Projects/planning
PROJECTS_ROOT=/home/jevido/Projects

# Derive project from the current working directory.
# e.g. /home/jevido/Projects/AUsites/admin  -> PROJECT=AUsites
#      /home/jevido/Projects/sentinel       -> PROJECT=sentinel
REL=${PWD#$PROJECTS_ROOT/}
PROJECT=${REL%%/*}

PROJECT_DIR="$PLANNING_DIR/$PROJECT"
PHASES_DIR="$PROJECT_DIR/phases"
AWESOME="$PROJECT_DIR/AWESOME.md"
SUMMARY="$PROJECT_DIR/SUMMARY.md"
```

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or `planning`, ask which project.

The three documents, and nothing else:

| Document | Holds | Written by |
|---|---|---|
| `AWESOME.md` | what is not built yet | `/idea` |
| `phases/` | what is being built now | `/planning` |
| `SUMMARY.md` | what the project is, because it was built | `/work` |

---

## Step 1 — Load the Board

Before saying anything, read:

- `$AWESOME` — the queue, and the cornerstone each segment sits under.
- `$SUMMARY` — what already exists, so you do not plan it twice.
- `ls $PHASES_DIR` and the frontmatter of the last phase's tasks — is anything still open?

**If a phase is unfinished**, say so first. Planning behind an open phase is fine; planning *around* it is not. Ask which the user wants.

## Step 2 — Spar

This is the part that matters, and it is a conversation, not a checklist.

Bring three things to it:

1. **What the code actually says.** Go read it. If the segment claims the admin does X, open the file and find out. A claim that turns out to be wrong changes the phase, and finding that out now costs minutes — finding it out in `/work` costs the phase.
2. **What it depends on.** Name what has to be true before this can start, and whether it is true today. If it is not, that dependency may be the phase instead.
3. **An opinion.** You have read the code and the backlog; say what you think should come next and why. A sparring partner with no position is a form.

Use `AskUserQuestion` for the genuine forks — where two answers mean materially different work. Do not use it for things you can settle by reading the code, and do not use it to ask permission to proceed.

Settle before writing anything:

- **Which segment**, and whether it is the whole segment or a slice of it. A segment too big for one phase gets sliced, and the rest stays in `AWESOME.md`.
- **Why now** — what this unblocks, or what it stops costing.
- **The seam** — where this phase stops. A phase ends somewhere a person can see it working.

Keep it short. Sparring is a handful of exchanges, not an interview.

## Step 3 — Write the Phase

```bash
mkdir -p "$PHASES_DIR"
SLUG=<kebab-case-slug>

LAST=$(ls "$PHASES_DIR/" 2>/dev/null | grep -E '^[0-9]{2}-' | sort | tail -1 | grep -oE '^[0-9]+' || echo "00")
NEXT=$(printf "%02d" $((10#$LAST + 1)))
PHASE_DIR="$PHASES_DIR/${NEXT}-${SLUG}"
mkdir -p "$PHASE_DIR"
```

Numbers keep their gaps and are never reused — an old commit message or branch name still points at a number, and reusing one makes it point at unrelated work. A new phase takes the next number after the highest that has ever existed.

`$PHASE_DIR/goal.md`, every field filled:

```markdown
# Phase ${NEXT} — <Title>

**Cornerstone:** <the `##` heading this came from in AWESOME.md>

## Goal

<One sentence: what this phase achieves.>

## What it entails

- <bullet>
- <bullet>

## What it does

<The running system after this phase completes, described as someone using it would see it.>

## Expected outcome

When all tasks are done:

- <observable outcome>
- <observable outcome>
```

## Step 4 — Write the Tasks

```bash
PHASE_DIR="$PHASES_DIR/<NN-slug>"
SLUG=<kebab-case-slug>

LAST=$(ls "$PHASE_DIR"/*.md 2>/dev/null | grep -v goal.md | sort | tail -1 | xargs -r basename | grep -oE '^[0-9]+' || echo "00")
NEXT=$(printf "%02d" $((10#$LAST + 1)))
TASK_FILE="$PHASE_DIR/${NEXT}-${SLUG}.md"
```

```markdown
---
status: todo
---

# ${NEXT} — <Task Title>

## What

<What this task produces — a concrete artifact, endpoint, component, screen.>

## Why

<Why it needs to exist, or what depends on it.>

## How

<Step-by-step, specific, naming real files and real functions. This is read by `/work` in a
fresh session with none of this conversation in context — everything it needs is here or
in the files it names.>

## Test

<How to verify it is done: commands to run, behaviour to observe.>

## Notes

<Gotchas, dependencies, constraints. Omit the section entirely if there is nothing.>
```

Task sizing: 1–4 hours each, run in number order. Ordered so that each one leaves the repo working — `/work` commits after every task.

Write **only this phase's tasks**. If a task would depend on a phase that does not exist yet, the phase ends before it.

## Step 5 — Drain the Segment

A segment leaves `AWESOME.md` the moment it becomes a phase, in the same commit — so it can never exist in two places.

- Delete the `###` segment, heading and bullets.
- Bullets that did **not** become tasks stay behind under the same segment. Never drop an idea by planning around it; say in the summary what was left.
- If that empties a cornerstone, leave the `##` heading and its one-line description. An empty cornerstone reads as "nothing queued here", which is worth knowing.

## Step 6 — Commit and Hand Off

Add **only** the phase directory and `AWESOME.md` — never `git add -A`. `/idea` and `/work` may be running in other terminals with their own half-finished writes in this repo.

```bash
cd /home/jevido/Projects/planning
git add "$PROJECT/phases/<NN-slug>" "$PROJECT/AWESOME.md"
git commit -m "plan(<project>): phase <NN> <title>"
```

Then print the phase, its tasks in order, and what was left behind in `AWESOME.md`. Say `/work` is ready to run.

---

## Hard Rules

- **One phase per invocation.** If the user asks for several, plan the first and say why the rest waits — the next one is planned when this one is close to done and the repo it assumes is real.
- **Read the code before writing a task.** A task written off a backlog bullet alone is a guess.
- **Never write to `SUMMARY.md`.** That is `/work`'s, and only when a phase completes.
- **Never invent a document.** Three files per project: `AWESOME.md`, `SUMMARY.md`, `phases/`. No roadmap, no stack file, no index. If something needs saying, it goes in one of the three.
- To insert a task between two existing ones, renumber the affected files by hand.
