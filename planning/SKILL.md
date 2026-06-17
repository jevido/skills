---
name: planning
description: >
  Create phases and tasks in the planning repo at /home/jevido/Projects/planning.
  Use when the user wants to plan, scope, or break down work into phases and tasks.
  Invoked with /planning <description of what to plan>.
---

# Planning Skill

Creates phases and tasks in `/home/jevido/Projects/planning`.

## Constants

```
PLANNING_DIR=/home/jevido/Projects/planning
PHASES_DIR=$PLANNING_DIR/phases
```

## What to Do When Invoked

1. **Understand scope** from the user's prompt and current conversation context.
   - Check for idea files relevant to the user's prompt. Look in `$PLANNING_DIR/console/ideas/` for console work, `$PLANNING_DIR/ideas/` for web/general work. If a match exists, use it as input context. After promoting it to a phase, delete the idea file and include it in the commit.
2. **Decide structure**: how many phases, what tasks each phase needs.
   - One phase per distinct deliverable or logical boundary.
   - Tasks are concrete, implementable units of work within a phase.
   - Aim for tasks that take 1–4 hours each.
3. **Create phases** (in order) using the shell logic below.
4. **Create tasks** for each phase using the shell logic below.
5. **Fill every template field** — no `<placeholder>` text left.

---

## Shell: Create a Phase

```bash
PLANNING_DIR=/home/jevido/Projects/planning
mkdir -p "$PLANNING_DIR/phases"
SLUG=<kebab-case-slug>

LAST=$(ls "$PLANNING_DIR/phases/" 2>/dev/null | grep -E '^\d{2}-' | sort | tail -1 | grep -oE '^\d+' || echo "00")
NEXT=$(printf "%02d" $((10#$LAST + 1)))
PHASE_DIR="$PLANNING_DIR/phases/${NEXT}-${SLUG}"
mkdir -p "$PHASE_DIR"
```

Then write `$PHASE_DIR/goal.md` with this template (fully filled):

```markdown
# Phase ${NEXT} — <Title>

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
PHASE_DIR="$PLANNING_DIR/phases/<NN-slug>"
SLUG=<kebab-case-slug>

LAST=$(ls "$PHASE_DIR"/*.md 2>/dev/null | grep -v goal.md | sort | tail -1 | xargs -r basename | grep -oE '^\d+' || echo "00")
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

## Ordering Rule

Tasks run in number order. Never start task N+1 before task N has `status: done`. To insert a task between existing ones, manually renumber the affected files.

---

## After Creating Files

- Print a summary: phases created, tasks per phase.
- If context suggests the work should start immediately, say so and recommend `/work`.
- Commit the planning repo if there are files to commit:
  ```bash
  cd /home/jevido/Projects/planning && git add -A && git commit -m "plan: <short summary of what was planned>"
  ```
