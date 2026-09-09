---
name: work
description: >
  Implement planning tasks in order from the current project's planning directory
  under /home/jevido/Projects/planning. Finds the next todo task, implements it,
  verifies it, marks it done, commits, and loops. Use when the user says /work,
  "start working", "implement tasks", or "continue working".
---

# Work Skill

Implements tasks from the current project's planning directory in strict sequential order, and stops when it runs out. It loops on its own — start it and leave it.

Planning is **always scoped to a project**. Phases live inside that project's directory under the planning repo.

`/idea` and `/planning` may be running in other terminals against this same planning repo. That is fine and expected: they write `AWESOME.md` and `phases/<new>`, this skill writes task frontmatter and `SUMMARY.md`. The one rule that keeps them out of each other's way is **stage only your own paths, never `git add -A`**.

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

**One command. Do not list phases, do not open task files to read their status.**

```bash
cd "$PHASES_DIR" && grep -H '^status:' */*.md | grep -v '/goal\.md:' | sort \
  | awk -F':' '$3 !~ /done|declined/ { print $1 " ->" $3; exit }'
```

Phase and task filenames are zero-padded, so lexical sort *is* execution order: the
single line this prints is the current task, and the hard rule below is satisfied by
construction. No output at all means every task is done — report that and stop.

The status it prints decides what happens next:

- `todo` — this is the current task, go to Step 2.
- `in_progress` — a previous session was interrupted here. Same thing: this is the
  current task. Re-establish where it got to from `git log` and the working tree
  before implementing, not by re-reading the whole phase.
- `blocked` — **stop and report.** Print the path, the title and the **Notes**
  section. Do not skip it, do not start anything after it.

**Hard rule:** Never move to phase N+1 until every task in phase N is `status: done`.

### Step 2 — Read Context

Read:
- The task file (all sections: What, Why, How, Test, Notes)
- The phase `goal.md` — **once per phase, not once per task.** Every task in a phase
  shares it, and it is already in context for the second task onward.
- Any referenced files mentioned in the task

Read nothing else from the planning repo. In particular: not the sibling task files,
not `AWESOME.md`, not `SUMMARY.md` (until Step 8 says so), and not the phases behind
this one. A task file states what it needs; a neighbouring task is somebody else's
turn and costs the same context as this one.

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

**Commit 2 — planning status** (in the planning repo). Stage the one task file and nothing else — another terminal may have uncommitted work here:
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

If a new phase appeared while you were working — `/planning` running in another terminal — that is normal. Pick it up on the next pass through Step 1.

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
- **Never** invent a document. Three files per project: `AWESOME.md`, `SUMMARY.md`, `phases/`. No roadmap, no status file, no index.
- **Never** `git add -A` in the planning repo. Stage the exact paths you wrote.

---

## Context Is The Budget

This skill loops until the context runs out, so how much a task costs decides how many
tasks a session gets through. The loop is designed to cost one task's worth of reading
per task — keep it that way:

- **Never re-scan.** Step 1 is one `grep` printing one line. A second pass over the
  phases directory, or opening task files to check their status, is the single most
  expensive mistake available here.
- **Read the slice, not the file.** `sed -n '120,180p'` and `git grep -n` over a
  known symbol beat reading a 900-line route. This repo has files that cost thousands
  of tokens to open in full and answer the question in twenty lines.
- **Verify with the cheap check.** `bun run test` per package (~1s) during the work.
  `svelte-check` is slow *and* verbose; run it once at the end of a phase and say so,
  rather than after every task.
- **Do not echo what you wrote.** No `cat` of a file you just edited, no `git diff`
  read back for confirmation, no re-reading a file after an `Edit` — the tool would
  have errored. Two lines of summary per task is the whole report.
- **Truncate loud commands.** Pipe test and build output through `tail -20`; on a
  failure, grep for the failing assertion rather than reading the whole run.

When context does get full (watch for system warnings or ~80% usage):
1. Finish the current task if it is `in_progress`.
2. Stop before starting the next task.
3. Report to the user:
   - Project
   - Last completed task
   - Next task to implement (path + title)
   - Any notes or blockers observed
4. Ask the user to continue in a new session with `/work`.
