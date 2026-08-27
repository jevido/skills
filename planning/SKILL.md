---
name: planning
description: >
  Create phases and tasks in the planning repo at /home/jevido/Projects/planning,
  scoped to the current project. Use when the user wants to plan, scope, or break
  down work into phases and tasks. Invoked with /planning <description of what to plan>.
---

# Planning Skill

Creates phases and tasks in `/home/jevido/Projects/planning/<project>`.

Planning is **always scoped to a project**. Phases live inside that
project's directory under the planning repo.

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
PHASES_DIR="$PROJECT_DIR/phases"
AWESOME="$PROJECT_DIR/AWESOME.md"
SUMMARY="$PROJECT_DIR/SUMMARY.md"
```

**Project mapping** (working dir → planning dir):

| Working dir                              | Planning dir                                |
|------------------------------------------|---------------------------------------------|
| `/home/jevido/Projects/allunited-docker` | `/home/jevido/Projects/planning/allunited-docker` |
| `/home/jevido/Projects/mono`             | `/home/jevido/Projects/planning/mono`       |
| `/home/jevido/Projects/sentinel`         | `/home/jevido/Projects/planning/sentinel`   |

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or
`planning`, the project is ambiguous — **ask the user which project** before creating
anything.

## What to Do When Invoked

1. **Detect project** using the logic above. Confirm it if ambiguous.
2. **Understand scope** from the user's prompt and current conversation context.
   - Read `$AWESOME` and find the segment (a `###` heading) the prompt names. That segment's
     bullets are the input: each one is a task or part of one. Note which cornerstone (`##`)
     it sits under — the phase inherits it, and `SUMMARY.md` will file the shipped work there.
   - If the segment is rough — bullets that are paragraphs, claims with no location, ideas that
     have not been checked against the code — **stop and say so**. Recommend `/awesome sharpen
     <segment>` first. A phase planned off an unsharpened segment plans against a repo that may
     not exist.
   - If the prompt names no segment, plan from the prompt alone and do not touch `$AWESOME`.
3. **Decide structure**: how many phases, what tasks each phase needs.
   - One phase per distinct deliverable or logical boundary.
   - Tasks are concrete, implementable units of work within a phase.
   - Aim for tasks that take 1–4 hours each.
4. **Create phases** (in order) using the shell logic below.
5. **Create tasks** for each phase using the shell logic below.
6. **Fill every template field** — no `<placeholder>` text left.

---

## Shell: Create a Phase

```bash
mkdir -p "$PHASES_DIR"
SLUG=<kebab-case-slug>

LAST=$(ls "$PHASES_DIR/" 2>/dev/null | grep -E '^[0-9]{2}-' | sort | tail -1 | grep -oE '^[0-9]+' || echo "00")
NEXT=$(printf "%02d" $((10#$LAST + 1)))
PHASE_DIR="$PHASES_DIR/${NEXT}-${SLUG}"
mkdir -p "$PHASE_DIR"
```

Then write `$PHASE_DIR/goal.md` with this template (fully filled):

```markdown
# Phase ${NEXT} — <Title>

**Cornerstone:** <the `##` heading this came from in AWESOME.md>

## Goal

<One sentence: what this phase achieves.>

## What it entails

- <bullet>
- <bullet>

## What it does

<Description of the running system after this phase completes.>

## Expected outcome

When all tasks in this phase are done:

- <observable outcome>
- <observable outcome>
```

---

## Shell: Create a Task

```bash
PHASE_DIR="$PHASES_DIR/<NN-slug>"
SLUG=<kebab-case-slug>

LAST=$(ls "$PHASE_DIR"/*.md 2>/dev/null | grep -v goal.md | sort | tail -1 | xargs -r basename | grep -oE '^[0-9]+' || echo "00")
NEXT=$(printf "%02d" $((10#$LAST + 1)))
TASK_FILE="$PHASE_DIR/${NEXT}-${SLUG}.md"
```

Then write `$TASK_FILE` with this template (fully filled):

```markdown
---
status: todo
---

# ${NEXT} — <Task Title>

## What

<What this task produces — a concrete artifact, endpoint, component, etc.>

## Why

<Why this needs to exist / what depends on it.>

## How

<Step-by-step implementation approach. Be specific.>

## Test

<How to verify the task is complete — commands to run, behaviors to observe.>

## Notes

<Gotchas, dependencies, constraints. Omit section entirely if nothing to add.>
```

---

## Draining the Segment

A segment leaves `AWESOME.md` the moment it becomes a phase. Once every task file is written:

- Delete the whole `###` segment from `$AWESOME`, heading and bullets.
- If that empties its cornerstone, leave the `##` heading and its one-line description in place — the cornerstone is the stable spine, shared with `SUMMARY.md`, and an empty one means "nothing queued here", which is worth reading.
- Anything in the segment that did **not** make it into a task stays behind as bullets under the same segment. Never drop an idea by planning around it; say in the summary what was left.
- Add the phase to `ROADMAP.md` if the project keeps one.

The deletion goes in the same commit as the phase, so a segment can never exist in two places.

---

## Ordering Rule

Tasks run in number order. Never start task N+1 before task N has `status: done`. To insert a task between existing ones, manually renumber the affected files.

---

## After Creating Files

- Print a summary: project, phases created, tasks per phase.
- If context suggests the work should start immediately, say so and recommend `/work`.
- Commit the planning repo if there are files to commit:
  ```bash
  cd /home/jevido/Projects/planning && git add -A && git commit -m "plan(<project>): <short summary of what was planned>"
  ```
