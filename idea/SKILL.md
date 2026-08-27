---
name: idea
description: >
  Dump an idea into the current project's AWESOME.md in the planning repo. Fast capture,
  no ceremony — it does not check the code, plan anything or ask questions.
  Use when the user just had an idea. Invoked with /idea <the idea>.
---

# Idea Skill

Dumps a thought into `/home/jevido/Projects/planning/<project>/AWESOME.md` and gets out of the way.

**Speed is the whole point.** No code checking, no verification, no clarifying questions, no scoping. If the idea is vague, capture it vague — a vague idea in the document beats a sharp one that was never written down. `/planning` is where it gets thought about.

## Constants & Project Detection

```bash
PLANNING_DIR=/home/jevido/Projects/planning
PROJECTS_ROOT=/home/jevido/Projects

# Derive project from the current working directory.
# e.g. /home/jevido/Projects/AUsites/admin  -> PROJECT=AUsites
#      /home/jevido/Projects/sentinel       -> PROJECT=sentinel
REL=${PWD#$PROJECTS_ROOT/}
PROJECT=${REL%%/*}

AWESOME="$PLANNING_DIR/$PROJECT/AWESOME.md"
```

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or `planning`, ask which project. That is the only question this skill is allowed to ask.

## The Document

`AWESOME.md` is one document per project, the backlog and the dump in one place. It is **only what is still to come** — a title, then cornerstones. No introduction, no explanation of what the document is for, no links to the other two, no dates. Anyone reading it wants the queue, not a preamble:

```markdown
# <Project> — awesome

## <Cornerstone>

<One line: who this serves and what for.>

### <Segment>

<Optional paragraph, only where the segment needs a why.>

- <one line per idea>
```

A **cornerstone** (`##`) names an audience and an outcome — `Marketing — helping clubs gain members`, not `Database`. It is the stable spine, shared with `SUMMARY.md`, so shipped work files itself under the heading its idea was queued beneath.

A **segment** (`###`) is the unit `/planning` turns into a phase.

## What to Do

1. Read `$AWESOME`. If it does not exist, create it: the title line, then cornerstones derived from the project's `CLAUDE.md` and its `phases/`. Never a placeholder list, and never an intro paragraph.
2. Put the idea where it belongs: an existing segment, a new segment under an existing cornerstone, or a new cornerstone. Read the existing `##` headings first — most ideas belong under one that is already there.
3. Write it as **one line per idea**. Several ideas in one prompt are several bullets; never merge them. Keep the user's own words and their emphasis — tidy the grammar, not the opinion.
4. If a thought genuinely needs a paragraph, it is a segment: give it a `###` heading and put the paragraph under it.
5. Commit, then print the cornerstone, the segment, and the line as written. Nothing else.

## Committing

Add **only** `AWESOME.md` — never `git add -A`. `/planning` and `/work` may be running in other terminals with their own half-finished writes in this repo.

```bash
cd /home/jevido/Projects/planning && git add "$PROJECT/AWESOME.md" && git commit -m "idea(<project>): <short title>"
```

## Not This Skill's Job

- Checking whether it already exists in the code — `/planning` does that, once, for the segment it is about to build.
- Deciding priority or order — `/planning` spars over that.
- Removing anything. Ideas leave `AWESOME.md` only when `/planning` turns them into a phase.
- Writing anything into the document that is not a future idea. No intro, no status, no "last checked" line, no pointer to `SUMMARY.md`. The moment it describes itself it stops being a queue.
