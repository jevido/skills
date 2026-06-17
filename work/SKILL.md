---
name: work
description: >
  Implement planning tasks in order from /home/jevido/Projects/planning.
  Finds the next todo task, implements it, verifies it, marks it done, commits, and loops.
  Use when the user says /work, "start working", "implement tasks", or "continue working".
---

# Work Skill

Implements tasks from `/home/jevido/Projects/planning` in strict sequential order.

## Constants

```
PLANNING_DIR=/home/jevido/Projects/planning
PHASES_DIR=$PLANNING_DIR/phases
```

---

## The Loop

Repeat until all tasks are done, a task is blocked, or context is running low:

### Step 1 — Find Next Task

```bash
ls /home/jevido/Projects/planning/phases/ | sort
```

For each phase directory (ascending order):
- Read `goal.md` for phase context.
- List task files: `ls <phase-dir>/*.md | grep -v goal.md | sort`
- Read each task file's frontmatter to get `status`.
- Skip if `status: done`.
- **Stop and report** if `status: blocked` — describe the blocker to the user, halt the loop.
- Take the first `status: todo` task. This is the current task.

**Hard rule:** Never move to phase N+1 until every task in phase N is `status: done`.

### Step 2 — Read Context

Read:
- The task file (all sections: What, Why, How, Test, Notes)
- The phase `goal.md`
- Any referenced files mentioned in the task

### Step 3 — Mark In Progress

Edit the task file frontmatter:
```
status: in_progress
```

### Step 4 — Implement

Follow the **How** section of the task exactly. Use all available tools (Read, Edit, Write, Bash, etc.). Stay in the working directory of the project being implemented (not the planning repo).

### Step 5 — Verify

Run every check described in the **Test** section. A task is only complete when:
- All Test checks pass
- No regressions introduced in adjacent functionality

If verification fails: fix the issue and re-verify. Do not mark done until tests pass.

### Step 6 — Mark Done

Edit the task file frontmatter:
```
status: done
```

### Step 7 — Commit

Two commits, in order:

**Commit 1 — project code** (in the project working directory):
```bash
git add <relevant files>
git commit -m "<type>(<scope>): <what was done>

Implements planning task: <phase-dir>/<task-file>"
```

**Commit 2 — planning status** (in the planning repo):
```bash
cd /home/jevido/Projects/planning
git add phases/<phase-dir>/<task-file>.md
git commit -m "done: <task title>"
```

### Step 8 — Loop

Go back to Step 1.

---

## Hard Rules

- **Never** start task N+1 if task N is not `status: done`.
- **Never** start phase N+1 if any task in phase N is not `status: done`.
- A task is only `done` when its **Test** checks pass — not when the code is written.
- Always produce two commits per completed task: one for project code, one for planning status.
- Never skip verification to go faster.

---

## Context Running Low

When context is getting full (watch for system warnings or ~80% context usage):
1. Finish the current task if it's `in_progress`.
2. Stop before starting the next task.
3. Report to the user:
   - Last completed task
   - Next task to implement (path + title)
   - Any notes or blockers observed
4. Ask the user to continue in a new session with `/work`.

---

## Blocked Task

If a task has `status: blocked`:
- Do not skip it.
- Do not start subsequent tasks.
- Report the blocked task path, title, and any notes from its **Notes** section.
- Ask the user how to proceed.
