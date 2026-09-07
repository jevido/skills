# CLI

Runs through the project's `yapyak` binary: `pnpm yapyak <cmd>`, `npx yapyak <cmd>`, or `bunx yapyak <cmd>`. Match the project's lockfile.

Conventions: boolean flags accept `=` (`--write=false`, `--write=$VAR`); `NO_COLOR` or `CI` strips color.

| Command | Purpose |
| --- | --- |
| `add <locale...>` | add locales |
| `translate [locale] [--force]` | fill missing translations |
| `retranslate <source> [--locale] [--as] [--file]` | re-translate one source string |
| `status [--json]` | coverage report |
| `check` | validate + gate CI |
| `clean [--write]` | remove orphan entries |
| `export [locale...] [--out <path>] [--split]` | dump translations as JSON |
| `info` | environment for bug reports |

## add

```bash
pnpm yapyak add sv
pnpm yapyak add sv da nb
```

Creates `<locale>.json` per tag in `localesDir` and regenerates the `Locale` type. With a translator configured, the new files are filled with translations of every existing source string.

## translate

```bash
pnpm yapyak translate            # every locale, every empty stub
pnpm yapyak translate sv         # one locale
pnpm yapyak translate --force    # re-translate everything
```

Needs a configured translator (errors out with a hint otherwise). Incremental: a failed or aborted run resumes at the next empty stub without re-spending tokens. `YAP0033` means one batch failed after retries; the others still landed.

**`--force` overwrites existing translations, hand edits included.** Commit locale files first. Never run it without the user explicitly asking.

## status

```bash
pnpm yapyak status
pnpm yapyak status --json
```

Read-only. Per-locale translated/total, bar, percentage; `defaultLocale` is always 100%. Translated = value is not an empty string — no quality judgement. Each homonym context counts as its own entry. Exits `1` when anything is missing, `0` otherwise (same with `--json`; parse `perLocale.<locale>.missing`). JSON shape is stable across versions.

Does not tell you: quality, cross-locale consistency, or diagnostics — that last one is `check`.

## check

```bash
pnpm yapyak check
```

Walks every source file, extracts every `t()`, and confirms: every source string exists in every locale file; every entry is non-empty; every translation has the same ICU placeholders and structure as its source. Exit `0` clean, non-zero otherwise. This is the CI gate.

## clean

```bash
pnpm yapyak clean            # dry-run list
pnpm yapyak clean --write    # delete
```

Finds translations whose source string no longer exists in the code (`YAP0053`). Dry-run by default — read the list, sanity-check it, then re-run with `--write`.

## export

```bash
pnpm yapyak export > translations.json
pnpm yapyak export --out translations.json
pnpm yapyak export --out dist/locales --split
```

Snapshot to stdout by default; `--out` writes a file; `--out <dir> --split` writes one file per locale.

## info

```bash
pnpm yapyak info
```

yapyak CLI version, Node version, OS, package manager, and the project's yapyak/Vite/TypeScript versions resolved from `node_modules`. No paths, no usernames — paste as-is into a bug report. Runs without `yapyak.config.ts` (works when the config is what's broken). Always exits `0`. Run it from the app or package that shows the problem; a declared-but-uninstalled package is listed with `(not installed)`.
