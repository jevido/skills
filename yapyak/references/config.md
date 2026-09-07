# `yapyak.config.ts`

Read from the project root as `yapyak.config.{ts,mts,mjs,js}`. Every field optional.

```ts
import { react } from '@yapyak/react/processor';
import { defineConfig } from 'yapyak/config';

export default defineConfig({
  processors: [react()]
});
```

## Field reference

| Field | Default | Sets |
| --- | --- | --- |
| `defaultLocale` | `'en'` | source language; final fallback |
| `localesDir` | `'locales'` | where locale JSON lives, relative to root |
| `include` | `['.']` | which files are scanned |
| `exclude` | tests, generated, `.d.ts`, `node_modules`, build output | which files are skipped |
| `processors` | `[]` | non-TS/JS file formats |
| `translator` | none | model that fills empty stubs |
| `autoTranslateThreshold` | `20` | new strings in one save before auto-translate holds off |
| `preserveTranslationsOnSourceEdit` | `true` without translator, `false` with one | keep a translation when the source string is edited in place |
| `persistence` | `'none'` | where the active locale is stored |
| `detectUserLocale` | `false` | detect first-visit locale |
| `syncHtmlAttributes` | `false` | keep `<html lang>` / `<html dir>` in sync |

**The set of locales is not a config field.** It is read from the JSON files in `localesDir`, one per BCP 47 tag. Add one with `yapyak add sv` (creates `locales/sv.json`, fills it through the translator, regenerates the `Locale` type) or by dropping the file in by hand.

### include / exclude

Each entry is a directory name, a glob, or a `RegExp`. A bare directory expands to every source file inside it across the extensions your processors handle. **Setting either field replaces the default** — extend instead:

```ts
import { defineConfig, DEFAULT_EXCLUDE, DEFAULT_INCLUDE } from 'yapyak/config';

export default defineConfig({
  include: ['apps/web', 'packages/ui/src'],
  exclude: [...DEFAULT_EXCLUDE, '**/*.vendor.ts']
});
```

Default exclude: `**/*.{test,spec}.*`, `**/__tests__/**`, `**/*.{stories,gen}.{ts,tsx,js,jsx,mjs,cjs}`, `**/*.d.ts`, `**/node_modules/**`, `**/dist/**`, `**/build/**`, `**/coverage/**`, `**/yapyak.config.*`.

### processors

The built-in parser handles `.ts .tsx .js .jsx .mts .mjs .cts .cjs` with no processor. Register one per non-TS framework format; each claims its own extensions.

| Framework | Import |
| --- | --- |
| React | `import { react } from '@yapyak/react/processor'` |
| Vue | `import { vue } from '@yapyak/vue/processor'` |
| Nuxt | `import { nuxt } from '@yapyak/nuxt/processor'` |
| Svelte | `import { svelte } from '@yapyak/svelte/processor'` |
| Astro | `import { astro } from '@yapyak/astro/processor'` |

`react({ rsc: true })` for React Server Components: only `'use client'` files get the locale subscription hook; server components still get their `t()` rewritten and read the request-bound locale from the SSR adapter. `rsc` is the only processor option.

Custom formats: `createProcessor()` from `yapyak/processor` with `{ id, extensions, parseSource?, runtime?, applyImport?, skipHmrCallback? }`. `offsetToOriginalPosition()` and `rangeFromOffsets()` map string indices back to `{ line, column }` for diagnostics. Parser failure surfaces as `YAP0048`.

### persistence

`'none'` (default) · `'cookie'` · `'local-storage'` · `'url'`, or an object for options:

```ts
persistence: { type: 'cookie', name: 'lang' },
```

### detectUserLocale / syncHtmlAttributes

`detectUserLocale: true` reads `Accept-Language` on the server and `navigator.languages` in the browser on a first visit only; the match falls through to `defaultLocale`. A persisted choice always wins.

`syncHtmlAttributes: true` keeps `<html lang>` and `<html dir>` current on every switch (direction from the locale's script). Turn it on for SPAs and Astro islands; leave it off when the layout sets the attributes itself (`getTextDirection(getLocale())`).

### Reading config at runtime

```ts
import { defaultLocale, getLocale, locales } from 'yapyak';
```

## Translators

Optional. Without one, stubs stay empty and are filled by hand. yapyak only ever fills empty stubs; existing translations are never overwritten (except `yapyak translate --force`).

```ts
import { anthropic } from '@yapyak/anthropic';

translator: anthropic({ apiKey: process.env.ANTHROPIC_API_KEY }),
```

| Provider | Import | Notes |
| --- | --- | --- |
| Anthropic | `@yapyak/anthropic` | Claude models |
| OpenAI | `@yapyak/openai` | plus `seed`, `organization`, `user`; OpenAI-compatible endpoints via `endpoint` + `headers` |
| Gemini | `@yapyak/gemini` | default `batchSize` 15 |
| Ollama | `@yapyak/ollama` | local, no API key; `batchSize` 8, `timeout` 120s, `maxRetries` 1 |
| Claude Code | `@yapyak/claude-code` | runs the local `claude` CLI in print mode on the developer's subscription — no API key; needs `claude` on `PATH`, signed in; `concurrency` 2, `timeout` 120s, `batchSize` 25, `context` `'minimal'` |

Shared options: `apiKey` (all but Ollama), `model`, `voice`, `glossary` (`Record<source, Record<locale, target>>`), `context` (`'none' | 'minimal' | 'rich'`, default `'minimal'` — how much call-site code is sent), `examples` (default 5, 0 when `context: 'none'`), `temperature` `0.2`, `maxTokens`, `timeout` `30_000`, `maxRetries` `2`, `batchSize` `25`, `concurrency` `5`, `headers`, `endpoint`.

Anything else: `createTranslator()` from `yapyak/translator`. Throw the typed errors (`TranslatorAuthError`, `TranslatorRateLimitError`, `TranslatorTimeoutError`, `TranslatorNetworkError`, `TranslatorInvalidResponseError`, `TranslatorSafetyError`, `TranslatorTruncatedError`) so retry/backoff behaves; forward the `AbortSignal`.

Large saves are guarded: a single save adding more than `autoTranslateThreshold` strings writes the stubs but skips auto-translate — run `yapyak translate` when ready. `0` disables auto-translation entirely.

## Save loop

Save a source file → extract `t()` calls → write/prune stubs in every locale file → translator fills empty stubs (subject to the threshold) → HMR updates the browser. Editing a locale file by hand also triggers HMR. Cache lives in `.yapyak/` (corruption is `YAP0032`).
