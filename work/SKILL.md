---
name: work
description: >
  Implement planning tasks in order from the current project's planning directory
  under /home/jevido/Projects/planning. Finds the next todo task, implements it,
  verifies it, marks it done, commits, and loops. Use when the user says /work,
  "start working", "implement tasks", or "continue working".
---

# Work Skill

Implements tasks from the current project's planning directory in strict sequential order.

Planning is **always scoped to a project**. Phases live inside that project's
directory under the planning repo.

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
SUMMARY="$PROJECT_DIR/SUMMARY.md"
```

**Project mapping** (working dir → planning dir):

| Working dir                              | Planning dir                                |
|------------------------------------------|---------------------------------------------|
| `/home/jevido/Projects/allunited-docker` | `/home/jevido/Projects/planning/allunited-docker` |
| `/home/jevido/Projects/mono`             | `/home/jevido/Projects/planning/mono`       |
| `/home/jevido/Projects/sentinel`         | `/home/jevido/Projects/planning/sentinel`   |

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or
`planning`, the project is ambiguous — **ask the user which project** before working.

---

## The Loop

Repeat until all tasks are done, a task is blocked, or context is running low:

### Step 1 — Find Next Task

```bash
ls "$PHASES_DIR/" | sort
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

Implements planning task: <project>/phases/<phase-dir>/<task-file>"
```

**Commit 2 — planning status** (in the planning repo):
```bash
cd /home/jevido/Projects/planning
git add "$PROJECT/phases/<phase-dir>/<task-file>.md"
git commit -m "done(<project>): <task title>"
```

### Step 8 — Was That the Last Task of the Phase?

If any task in this phase is still `todo`, skip to Step 9.

If every task in the phase is now `done`, the phase is complete — **update `$SUMMARY`** before moving on.

`SUMMARY.md` is what the project *is*, written for someone who has never opened the repo. It is not a task log and not a changelog: no phase-by-phase history, no dates per line, no implementation detail. Its `##` headings are the **same cornerstones** as `AWESOME.md`, so a capability lands under the heading its idea was queued beneath — the phase's `goal.md` carries that cornerstone in its header.

```markdown
# <Project> — what it is

<One paragraph: what this project is and who it serves.>

## <Cornerstone>

<One line: who this cornerstone serves and what for.>

- **<Capability>** — <one sentence in the user's words: what a person can now do that they could not before.>
```

Rules for the write:

- **Extend before adding.** A phase that improved something already listed edits that line; it does not add a second one beside it. Two lines about the same capability means a reader cannot tell what the product does.
- **A capability, not a phase.** "Clubs can invite people and manage who has access" is a capability. "Phase 26 shipped the invitations screen" is a task log.
- **The user's words.** Name the screen, not the component. No file paths, no table names, no framework names.
- **Nothing is ever removed** unless the capability itself was removed — then the line goes, in the same commit as the removal.
- **A phase can add nothing.** Groundwork with no visible outcome extends the cornerstone's one-line description at most, or nothing at all. Do not invent a capability to have something to write.
- If `$SUMMARY` does not exist, create it: derive the cornerstones from the completed phases' `goal.md` headers and from `AWESOME.md`.

Commit it with the phase:

```bash
cd /home/jevido/Projects/planning
git add "$PROJECT/SUMMARY.md" "$PROJECT/phases/<phase-dir>"
git commit -m "done(<project>): phase <NN> <title>"
```

Then report the completed phase to the user, and say what it added to SUMMARY.md.

### Step 9 — Loop

Go back to Step 1.

---

## Hard Rules

- **Never** start task N+1 if task N is not `status: done`.
- **Never** start phase N+1 if any task in phase N is not `status: done`.
- A task is only `done` when its **Test** checks pass — not when the code is written.
- Always produce two commits per completed task: one for project code, one for planning status.
- Never skip verification to go faster.
- **Never** finish a phase without updating `SUMMARY.md` — or deciding, explicitly and out loud, that the phase added no capability worth naming.
- **Never** write a task, a date or a phase number into `SUMMARY.md`. That document has no history in it.

---

## Context Running Low

When context is getting full (watch for system warnings or ~80% context usage):
1. Finish the current task if it's `in_progress`.
2. Stop before starting the next task.
3. Report to the user:
   - Project
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
