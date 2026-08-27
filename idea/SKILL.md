---
name: idea
description: >
  Capture a quick idea into the current project's ideas folder under the planning repo.
  Use when the user just had an idea and wants it saved without blocking current phases.
  Invoked with /idea <description of the idea>.
---

# Idea Skill

Captures an idea into `/home/jevido/Projects/planning/<project>/ideas/` without
touching phases or tasks.

Ideas are **always scoped to a project**, same as phases.

## Constants & Project Detection

```bash
PLANNING_DIR=/home/jevido/Projects/planning
PROJECTS_ROOT=/home/jevido/Projects

# Derive project from the current working directory.
# e.g. /home/jevido/Projects/mono/apps/web  -> PROJECT=mono
#      /home/jevido/Projects/sentinel       -> PROJECT=sentinel
REL=${PWD#$PROJECTS_ROOT/}
PROJECT=${REL%%/*}

IDEAS_DIR="$PLANNING_DIR/$PROJECT/ideas"
```

**Project mapping** (working dir → planning dir):

| Working dir                              | Planning dir                                |
|------------------------------------------|---------------------------------------------|
| `/home/jevido/Projects/allunited-docker` | `/home/jevido/Projects/planning/allunited-docker` |
| `/home/jevido/Projects/mono`             | `/home/jevido/Projects/planning/mono`       |
| `/home/jevido/Projects/sentinel`         | `/home/jevido/Projects/planning/sentinel`   |

If `PWD` is not under `/home/jevido/Projects/`, or `PROJECT` resolves to empty or
`planning`, the project is ambiguous — **ask the user which project** before saving.

The slug should NOT repeat the project name — the directory provides that context.
Example: a mono idea about "container operations" → `mono/ideas/container-operations.md`,
not `mono/ideas/mono-container-operations.md`.

## What to Do When Invoked

1. **Detect project** using the logic above. Confirm it if ambiguous.
2. **Extract the idea** from the user's prompt — title + any context they provided.
3. **Generate a slug** from the title (kebab-case, lowercase, no special chars, no project prefix).
4. **Dedup**: if `$IDEAS_DIR/<slug>.md` already exists, append `-2`, `-3`, etc.
5. **Create the file** using the template below, fully filled — no placeholders.
6. **Commit** the planning repo.
7. **Print** the file path and suggest `/planning <idea title>` when ready to scope it.

---

## Shell: Create the Idea File

```bash
mkdir -p "$IDEAS_DIR"

SLUG=<kebab-case-slug-no-project-prefix>

# Dedup
FILE="$IDEAS_DIR/${SLUG}.md"
N=2
while [ -f "$FILE" ]; do
  FILE="$IDEAS_DIR/${SLUG}-${N}.md"
  N=$((N + 1))
done
```

Then write `$FILE` with this template (fully filled):

```markdown
# Idea — <Title>

## What it is

<One sentence: what this idea is.>

## What it entails

- <rough scope bullet>
- <rough scope bullet>

## Why it matters

<What problem it solves or value it adds.>

## Expected outcome

When built:

- <observable outcome>
- <observable outcome>
```

---

## After Creating the File

- Print: project + file path created.
- Say: "Run `/planning <title>` when ready to scope this into phases."
- Commit:
  ```bash
  cd /home/jevido/Projects/planning && git add -A && git commit -m "idea(<project>): <short title>"
  ```
