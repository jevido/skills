---
name: idea
description: >
  Capture a quick idea into the planning repo under its project's ideas folder.
  Use when the user just had an idea and wants it saved without blocking current phases.
  Invoked with /idea <description of the idea>.
---

# Idea Skill

Captures an idea into `<project>/ideas/` without touching phases or tasks.

## Constants

```
PLANNING_DIR=/home/jevido/Projects/planning
```

## Project Detection

Infer the project from the user's prompt and conversation context:

| Prompt mentions | Ideas dir |
|----------------|-----------|
| console, server management, terminal UI, CLI | `$PLANNING_DIR/console/ideas/` |
| web app, SPA, browser, frontend | `$PLANNING_DIR/ideas/` |
| unspecified / general | `$PLANNING_DIR/ideas/` |

Use only what's clearly implied. When unsure, default to `$PLANNING_DIR/ideas/`.

The slug should NOT repeat the project name — the directory provides that context.
Example: a console idea about "container operations" → `console/ideas/container-operations.md`, not `console/ideas/console-container-operations.md`.

## What to Do When Invoked

1. **Extract the idea** from the user's prompt — title + any context they provided.
2. **Detect project** using the table above → set `IDEAS_DIR`.
3. **Generate a slug** from the title (kebab-case, lowercase, no special chars, no project prefix).
4. **Dedup**: if `$IDEAS_DIR/<slug>.md` already exists, append `-2`, `-3`, etc.
5. **Create the file** using the template below, fully filled — no placeholders.
6. **Commit** the planning repo.
7. **Print** the file path and suggest `/planning <idea title>` when ready to scope it.

---

## Shell: Create the Idea File

```bash
PLANNING_DIR=/home/jevido/Projects/planning
IDEAS_DIR="<detected-ideas-dir>"
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

- Print: file path created.
- Say: "Run `/planning <title>` when ready to scope this into phases."
- Commit:
  ```bash
  cd /home/jevido/Projects/planning && git add -A && git commit -m "idea: <short title>"
  ```
