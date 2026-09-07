# Setup

Order: install → `yapyak.config.ts` → bundler plugin → SSR adapter (if any) → `yapyak add <locale>` → first `t()`. Re-run the detection script afterwards; it should report `USES`.

## Requirements

Node ≥ 22.22 and Vite ≥ 8 in every case. Plus:

| Framework / adapter | Also needs |
| --- | --- |
| React | React ≥ 19 |
| React Router | React ≥ 19, React Router ≥ 7.9, `future.v8_middleware: true` |
| TanStack Start | React ≥ 19, TanStack Start ≥ 1.168 |
| Vue | Vue ≥ 3.4 |
| Nuxt | Vue ≥ 3.4 + Nuxt |
| Svelte | Svelte 5 (runes) |
| SvelteKit | Svelte 5 + SvelteKit |
| Astro | Astro |

No Vite → yapyak does not apply.

## Install

Always `yapyak` + `@yapyak/vite` + the framework package. Add an SSR adapter package and/or a translator package as needed.

```bash
pnpm add yapyak @yapyak/vite @yapyak/react
pnpm add yapyak @yapyak/vite @yapyak/vue
pnpm add yapyak @yapyak/vite @yapyak/svelte
pnpm add yapyak @yapyak/vite @yapyak/astro
```

Adapters: `@yapyak/react-router`, `@yapyak/tanstack-start`, `@yapyak/sveltekit`, `@yapyak/nuxt`.
Translators: `@yapyak/anthropic`, `@yapyak/openai`, `@yapyak/gemini`, `@yapyak/ollama`, `@yapyak/claude-code`.

Astro uses `@yapyak/astro/integration` instead of the Vite plugin. Nuxt uses the `@yapyak/nuxt` module (which registers the plugin itself).

## `yapyak.config.ts`

One processor per framework file format:

```ts
import { react } from '@yapyak/react/processor';   // or vue / nuxt / svelte / astro
import { defineConfig } from 'yapyak/config';

export default defineConfig({
  processors: [react()]
});
```

Add a translator here if wanted — see `config.md`. Note `@yapyak/claude-code` needs no API key (uses the local `claude` CLI).

## Bundler plugin

```ts
// vite.config.ts
import { yapyak } from '@yapyak/vite';
import { defineConfig } from 'vite';

export default defineConfig({ plugins: [yapyak()] });
```

```ts
// astro.config.ts
import { yapyak } from '@yapyak/astro/integration';
export default defineConfig({ integrations: [yapyak()] });
```

```ts
// nuxt.config.ts
export default defineNuxtConfig({ modules: ['@yapyak/nuxt'] });
```

`YapyakOptions`: `fixedLocale` (lock the build to one locale), `root` (directory `yapyak.config.ts`, `localesDir`, and file ids resolve from).

Missing plugin with the runtime loaded is diagnostic `YAP0021`.

## SSR adapters — per-request locale context

Without one, `getLocale()` falls back to a module-global during SSR and concurrent requests can see each other's locale (`YAP0022`, `YAP0029`).

```ts
// src/hooks.server.ts (SvelteKit)
export { handle } from '@yapyak/sveltekit';
// composing:
import { sequence } from '@sveltejs/kit/hooks';
import { handle as yapyakHandle } from '@yapyak/sveltekit';
export const handle = sequence(yapyakHandle, authHandle);
```

SvelteKit also exposes `%yapyak.lang%` / `%yapyak.dir%` for `src/app.html`:
```html
<html lang="%yapyak.lang%" dir="%yapyak.dir%">
```

```ts
// src/start.ts (TanStack Start)
import { createStart } from '@tanstack/react-start';
import { middleware } from '@yapyak/tanstack-start';
export const startInstance = createStart(() => ({ requestMiddleware: [middleware] }));
```

```tsx
// app/root.tsx (React Router — needs future.v8_middleware: true)
import { middleware as yapyakMiddleware } from '@yapyak/react-router';
export const middleware: Route.MiddlewareFunction[] = [yapyakMiddleware];
```

Custom framework: `withResponse()` from `yapyak/adapter` wraps a request so `setLocale()` can write its cookie and `getLocale()` is request-scoped.

## First locale, first call

```bash
pnpm yapyak add sv        # creates locales/sv.json, regenerates the Locale type
```

```tsx
export function SaveButton() {
  return <button>{t('Save changes')}</button>;
}
```

Save. The extractor writes `{"src/…/save-button.tsx": {"Save changes": ""}}` into every locale file. Empty stub → the source string renders. Fill it (translator or by hand) → the translation renders. Locale resets on reload until `persistence` is configured.

## Locale type narrowing

`yapyak add` regenerates this; write it by hand only when creating locale files manually:

```ts
declare module 'yapyak' {
  interface Register {
    Locale: 'en' | 'sv' | 'da';
  }
}
```

Narrows `Locale` from `string` to a literal union, so `t.in('xx', …)` and `setLocale('xx')` become compile errors.

## Fixed-locale builds

One bundle per language, for static deploys. Build option, not a config field — the value must be one of your locales or the build throws:

```ts
yapyak({ fixedLocale: process.env.YAPYAK_LOCALE })   // vite / astro integration
```
```ts
yapyak: { fixedLocale: 'sv' }                        // nuxt.config.ts
```
```bash
YAPYAK_LOCALE=sv pnpm build
```
