---
name: yapyak
description: Detect whether a project uses yapyak (Vite i18n where the English source string IS the translation key) and then act on the answer — write t() calls correctly, fix locale files, wire the Vite plugin/config/translator, run the CLI, or set it up from scratch. Use when asked "does this project use yapyak", "check for yapyak", "add i18n", "translate this string/component", "why is this string untranslated", when a YAP#### diagnostic appears, or when yapyak.config.ts, @yapyak/*, or a locales/*.json catalog shows up in the work.
---

# yapyak

i18n for Vite apps. The English source string is the key: `t('Sign up')`, never `t('auth.signupButton')`. Catalogs are JSON in `localesDir`, keyed by source file then source string. Every `t()` is rewritten at build time into an inline catalog lookup; catalogs code-split along Vite routes.

Docs: <https://yapyak.dev> · machine-readable index: <https://yapyak.dev/llms.txt> · any page + `.md` returns markdown (e.g. `https://yapyak.dev/guide/writing/plurals.md`).

## Step 1 — detect (always first, never guess)

```bash
bash ~/.claude/skills/yapyak/scripts/detect-yapyak.sh [dir]   # default: cwd
```

Read-only. Exit code is the verdict: `0` USES · `1` PARTIAL · `2` NOT_USED · `3` no directory.

It reports: app root, declared vs installed `yapyak`/`@yapyak/*` packages, `yapyak.config.*`, whether `yapyak()` is registered in the bundler config, source files importing yapyak and their `t()` count, `defaultLocale`/`localesDir`/`translator`, every locale file with `entries empty-stubs source-files` counts, packages the config imports but `package.json` does not declare, and other i18n libraries present.

In a monorepo, run it on the app directory, not the repo root.

## Step 2 — act on the verdict

### USES

State the version, locales, translator, and coverage from the report, then do the actual task under these rules:

- Source string is the key. Static literal only — no template literals, no variables, no concatenation. Runtime values are ICU placeholders (`references/writing.md`).
- Never invent key names, never restructure catalogs by hand, never reorder or reformat a locale JSON file wholesale — the extractor owns those files.
- Adding a `t()` call is the whole job: on save the extractor writes empty stubs into every locale file. Do not hand-write stubs.
- Only ever fill *empty* stubs. Existing translations are never overwritten (that is `--force`, and it is destructive).
- Adding a locale = `yapyak add <tag>` (or dropping in `<tag>.json`), not a config field.
- A `t()` call at module scope is a bug (`YAP0055`): it evaluates once and, on the server, leaks across requests. Put it inside the component/function.

If the report shows empty stubs, missing packages, or a mis-wired config, say so and offer the fix — do not silently work around it.

Verification, in order of cost: `pnpm yapyak status` (coverage, non-zero when anything is missing) → `pnpm yapyak check` (CI gate: every string present, non-empty, ICU-consistent) → `pnpm yapyak clean` (dry-run list of orphans; `--write` deletes). Swap `pnpm` for `npx`/`bunx` to match the project's lockfile. `references/cli.md`.

### PARTIAL

One or two of {dependency, `yapyak.config.*`, bundler plugin} present. The `gaps:` section names what is missing; close exactly that, then re-run detection. Common cases:

| Gap | Fix |
| --- | --- |
| deps declared, no config | write `yapyak.config.ts` with the framework processor (`references/config.md`) |
| config + deps, no plugin | add `yapyak()` from `@yapyak/vite` to `vite.config.ts` plugins |
| runtime loaded, plugin missing | that is diagnostic `YAP0021` — same fix |
| declared but not installed | run the project's package manager install |
| config imports an undeclared package | add that package to `package.json` |

### NOT_USED

Do not install anything unprompted. Report the finding, then:

1. Check eligibility — yapyak is **Vite-only** and needs Node ≥ 22.22, Vite ≥ 8, plus a supported framework (React 19, Vue 3.4, Svelte 5, Astro) or adapter (Nuxt, SvelteKit, TanStack Start 1.168, React Router 7.9 with `future.v8_middleware`). No Vite, or a non-JS project (PHP, Rails, Django) → yapyak does not apply; say that plainly and stop.
2. If another i18n library is already in `package.json`, name it. Two i18n runtimes in one app is a migration, not an addition — ask before touching it.
3. If eligible and the user wants it, follow `references/setup.md` (install → config → plugin → SSR adapter → `yapyak add <locale>` → first `t()`), then re-run detection to confirm `USES`.

## References

Load only what the task needs.

| File | Covers |
| --- | --- |
| `references/writing.md` | `t()`, params, plurals, selects, rich text, homonyms (`t.as`), locale override (`t.in`), `format.*`, locale switching |
| `references/config.md` | every `yapyak.config.ts` field, processors, translators and their options, locale-file shape |
| `references/cli.md` | `add`, `translate`, `retranslate`, `status`, `check`, `clean`, `export`, `info` |
| `references/setup.md` | install matrix, per-framework config, Vite plugin, SSR adapters, fixed-locale builds, `Register` type |
| `references/diagnostics.md` | YAP0001–YAP0055, one line each |

A `YAP####` in output: look it up in `references/diagnostics.md` first, then `https://yapyak.dev/reference/diagnostics/YAP####.md` for the long form.
