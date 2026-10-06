---
name: planning
description: >
  Spar over what to build next, then plan exactly one phase of it into the planning repo at
  /home/jevido/Projects/planning, or write a goal for ralph to work toward. Use when the user
  wants to decide what comes next, scope it, break it into tasks, or set a goal. Invoked with
  /planning [what to plan], or /planning goal [what to achieve].
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
# Goals: one directory each, beside phases/.
#   $PROJECT_DIR/<goal>/GOAL.md   what to achieve; frontmatter status: todo|running|stopped|succeeded|failed
#   $PROJECT_DIR/<goal>/NOTES.md  the choices ralph made for it instead of asking
```

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or `planning`, ask which project.

The documents, and nothing else:

| Document | Holds | Written by |
|---|---|---|
| `AWESOME.md` | what is not built yet (optional; `/planning` reads it, never writes it) | `/idea` |
| `<goal>/GOAL.md` | an outcome to work toward, phase after phase, and what is fixed on the way | the user, or `/planning goal`; ralph sets its `status` |
| `<goal>/NOTES.md` | the choices ralph made for that goal instead of asking | ralph |
| `phases/` | what is being built now | `/planning` |
| `SUMMARY.md` | what the project is, because it was built | `/work` |

A goal is **open** until its `status` is `succeeded` or `failed`. Goals stay in their directory when they end — they are the record of what was aimed for — so the next one can be written while ralph still works the current one.

---

## Writing a Goal — `/planning goal`

When the user invokes `/planning goal …`, the output is a `GOAL.md`, not a phase. Do Step 1, then spar the same way as Step 2, but about the outcome, not the next slice: what is true when this goal has succeeded, what is fixed on the way there (stack, boundaries, what must not change), and the order to work in. Ralph reads it every step with no one to ask, so whatever it leaves open, ralph will decide alone.

```bash
GOAL_SLUG=<kebab-case-slug>   # lowercase, never tail, stop or phases
GOAL_FILE="$PROJECT_DIR/$GOAL_SLUG/GOAL.md"
mkdir -p "$PROJECT_DIR/$GOAL_SLUG"
```

A slug that already exists is a different goal: pick another one, never overwrite it.

```markdown
---
status: todo
max: 400
model: claude-opus-5-5
---

# <Project> — <the outcome, in a few words>

<One paragraph: what is true when this goal has succeeded, and why it is worth it.>

## Fixed

- <what is not up for choice: stack, boundaries, what must keep working>

## Order

1. <the first slice, ending somewhere a person can see it working>
2. <…>

## Done when

- <observable outcome that says the goal succeeded>
```

Always write `max:` (steps ralph takes before he gives up) and `model:` (the model for every step), so the goal shows what it runs with; the values above are ralph's defaults, change them when the user asks. Write no phases for it — ralph plans them, one at a time.

```bash
cd /home/jevido/Projects/planning
git add "$PROJECT/$GOAL_SLUG/GOAL.md"
git commit -m "goal(<project>): <goal-slug>"
```

Then say it is ready for `ralph $GOAL_SLUG`, and whether another goal is open in the project (ralph runs one at a time; with several open it must be told which).

---

## Step 1 — Load the Board

Before saying anything, read:

- `$AWESOME`, if it exists — the queue, and the cornerstone each segment sits under. Read-only: this skill never creates, edits or commits it.
- `$SUMMARY` — what already exists, so you do not plan it twice.
- The open goals: `$PROJECT_DIR/*/GOAL.md` whose `status` is not `succeeded` or `failed`. A phase usually serves one of them; ralph's prompt names it.
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

- **Which segment**, and whether it is the whole segment or a slice of it. A segment too big for one phase gets sliced; the rest is named in the hand-off, not written anywhere.
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

**Cornerstone:** <the `##` heading this sits under — from AWESOME.md if the idea came from there, else the matching SUMMARY.md heading>
**Goal:** <the goal directory this phase serves, e.g. `services-behind-two-uis` — or `—` when it serves none>

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

**Cheaper model for pattern tasks.** Add `model: claude-sonnet-5` to a task's frontmatter (under `status`) when it repeats a pattern the repo already has and its **How** names the existing example to copy, e.g. one more API endpoint shaped like an existing one, one more service template like the last, a page restyled the way a named page already was. Ralph runs such a task on that model once and falls back to the goal's model if it is not done after that. Leave it out (the goal's model) for anything that designs or decides: a new context, aggregate or invariant, a data migration, auth, permissions or security, the first of its kind, and every sweep or end-to-end task. When unsure, leave it out.

Task sizing: 1–4 hours each, run in number order. Ordered so that each one leaves the repo working — `/work` commits after every task.

Write **only this phase's tasks**. If a task would depend on a phase that does not exist yet, the phase ends before it.

## Step 5 — Commit and Hand Off

Add **only** the phase directory — never `git add -A`. Do not touch `AWESOME.md`, even to drain the segment that became this phase. `/idea` and `/work` may be running in other terminals with their own half-finished writes in this repo.

```bash
cd /home/jevido/Projects/planning
git add "$PROJECT/phases/<NN-slug>"
git commit -m "plan(<project>): phase <NN> <title>"
```

Then print the phase, its tasks in order, and what was left out of it — ideas raised while sparring that did not become tasks. Never drop one silently; if the user wants it kept, it is theirs to queue. Say `/work` is ready to run.

---

## Hard Rules

- **One phase per invocation.** If the user asks for several, plan the first and say why the rest waits — the next one is planned when this one is close to done and the repo it assumes is real.
- **Read the code before writing a task.** A task written off a backlog bullet alone is a guess.
- **Never write to `SUMMARY.md`, `AWESOME.md` or `NOTES.md`.** `SUMMARY.md` is `/work`'s, and only when a phase completes; `AWESOME.md` is `/idea`'s; `NOTES.md` is ralph's. This skill writes `phases/`, and a new `<goal>/GOAL.md` under `/planning goal`, and nothing else.
- **Never edit a goal that has started.** A `GOAL.md` whose `status` is anything but `todo` belongs to ralph's run or to the record; a change of mind is a new goal. Never set `status` yourself beyond writing `todo`.
- **Never invent a document.** Per project: `AWESOME.md`, `SUMMARY.md`, `phases/`, and one directory per goal holding `GOAL.md` and `NOTES.md`. No roadmap, no stack file, no index. If something needs saying, it goes in the phase or the goal.
- To insert a task between two existing ones, renumber the affected files by hand.

