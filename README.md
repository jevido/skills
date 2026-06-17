# claude-skills

Skills for [Claude Code](https://claude.ai/code). Each subdirectory is a skill — a `SKILL.md` file Claude loads when you invoke `/skill-name`.

## Install

```bash
git clone https://github.com/jevido/skills ~/.claude/skills
```

Claude Code picks up skills automatically. No extra config needed.

---

## idea / planning / work

Three skills that form a complete loop for capturing and shipping work.

```
/idea       ←  have an idea, don't need it now
/planning   ←  ready to scope a phase
/work       ←  let Claude implement everything autonomously
```

### `/idea` — park it without interrupting current work

Got an idea but not ready to act on it? `/idea` saves it as a structured file in your planning repo and gets out of the way.

```
/idea add a dark mode toggle to the settings page
```

Creates `ideas/dark-mode-toggle.md`, commits it, suggests `/planning` when you're ready. Nothing else changes.

---

### `/planning` — scope a phase

A phase is like a sprint, but without any concept of time — just a goal and the tasks needed to reach it.

```
/planning i want the web UI to be vibrant and welcoming, ask me 20 questions for context
```

Claude will ask clarifying questions before planning. Give it as much or as little direction as you want — the more context, the sharper the tasks.

If a matching idea file exists, Claude promotes it (uses it as context, then deletes it).

Output:

```
phases/
  01-visual-refresh/
    goal.md
    01-color-system.md
    02-typography.md
    03-hero-section.md
  02-interactions/
    goal.md
    01-hover-states.md
    02-page-transitions.md
```

Each task file:

```markdown
---
status: todo
---

# 01 — Color System

## What   ← artifact produced
## Why    ← what depends on it
## How    ← step-by-step implementation
## Test   ← how to verify it's done
## Notes  ← gotchas, constraints (optional)
```

Tasks run in numeric order. Phase N+1 never starts until every task in phase N is `done`.

---

### `/work` — fully autonomous execution

Claude picks up where planning left off and works through every task without stopping.

```
/work
```

For each task, Claude:
1. Reads the task, phase goal, and referenced files
2. Marks `status: in_progress`
3. Implements following the **How** section exactly
4. Runs every **Test** check — only continues when they pass
5. Marks `status: done`
6. Makes two commits: one for project code, one for planning status
7. Moves to the next task

If context runs low, Claude finishes the current task, reports what's next, and asks you to continue with `/work` in a new session.

If a task is `status: blocked`, the loop stops and reports the blocker — nothing is skipped.

---

### Full example

```
/idea let users export their data as CSV
→ Created ideas/export-csv.md

/planning export CSV, keep it simple, ask me anything unclear
→ Claude asks 3 questions, then creates:
  phases/01-export-api/ (3 tasks)
  phases/02-ui-button/ (2 tasks)

/work
→ implements all 5 tasks in order, commits each, done
```

---

## Other skills

| Skill | Invocation | What it does |
|-------|-----------|--------------|
| `accessibility` | `/accessibility` | Audit and improve web a11y against WCAG 2.2 |
| `omarchy` | `/omarchy` | Customize Linux desktop config (Hyprland, Waybar, themes) |
| `svelte-code-writer` | `/svelte-code-writer` | Svelte 5 docs lookup and component analysis |
| `svelte-core-bestpractices` | `/svelte-core-bestpractices` | Best practices for reactivity, events, styling in Svelte 5 |
| `find-skills` | `/find-skills` | Discover and install skills from the ecosystem |

---

## Skill file format

```markdown
---
name: your-skill-name
description: >
  What this skill does and when to invoke it.
  Include trigger phrases — Claude reads this to decide when to suggest the skill.
---

# Skill Title

Instructions, templates, rules, shell logic...
```
