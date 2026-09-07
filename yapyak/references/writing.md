# Writing translatable text

## `t()`

```ts
import { t } from 'yapyak';

t('Save changes');
```

The string passed is both the source string and the key. Works in `.ts/.tsx/.js/.jsx/.mts/.mjs/.cts/.cjs`, plus `<script>`/template of `.vue`, `<script>`/markup of `.svelte`, frontmatter/template of `.astro` (those three need their processor registered).

| Form | Purpose |
| --- | --- |
| `t(source)` | translate for the active locale |
| `t(source, params)` | with placeholder values |
| `t.in(locale, source)` | force one locale for this call |
| `t.as(context, source)` | disambiguate identical sources (homonyms) |

Nuxt auto-imports `t` and `RichText`; everything else is a normal import.

### Hard rules the compiler enforces

```ts
✓ t('Hi {name}', { name })
✗ t()                        // YAP0001
✗ t('')                      // YAP0003
✗ t(`Hello ${name}`)         // YAP0002 — dynamic source can't be extracted
✗ t(someVariable)            // YAP0002
✗ t('Hi {name}', params)     // YAP0006 — params must be an inline object literal
✗ const c = t.in('sv'); c.as('action','Open')  // YAP0020 — chains are inline-only
```

A `t()` at module scope is `YAP0055`: evaluated once at import, never re-evaluated on locale change, and shared across SSR requests. Keep calls inside components/functions.

## Params

```ts
t('Hi {name}', { name: 'Ada' });                          // 'Hej Ada'
t('You have {count} messages from {sender}', { count: 3, sender: 'Alex' });
```

Placeholder names in `{braces}`. TypeScript infers the params object from the source string: a missing key, an extra key, or a typo is a compile error (`YAP0004`, `YAP0005`, `YAP0049`). Simple placeholders take `string | number`. Order is irrelevant — translations may reorder freely. Lists are formatted outside `t()` with `format.list`.

## Plurals

```ts
t('You have {count, plural, one {# message} other {# messages}}', { count: 5 });
```

`#` renders the count with the locale's number rules (`1,000 messages`). Write only the categories the source language needs; the translator fills the target locale's own CLDR categories. `other` is mandatory (`YAP0008`). Categories: `zero one two few many other`. Exact matches like `=1` are allowed. A branch outside the target locale's categories is `YAP0045`; a bogus source branch is `YAP0046`.

## Selects

```ts
t('{role, select, admin {Admin panel} editor {Editor view} other {Reader view}}', { role });
```

Switches on a string; keys are yours to choose. `other` mandatory (`YAP0008`) and used for any unmatched value. Translators may add/remove/merge branches per locale (e.g. gendered forms in Spanish).

## Rich text

```tsx
import { RichText } from '@yapyak/react';

<RichText
  value={t('Read our <link>privacy policy</link> for details.')}
  link={(children) => <a href="/privacy">{children}</a>}
/>
```

Pair tags (`<link>…</link>`) become props taking `(children) => node`; void tags (`<br/>`) become no-arg props returning a node. Required props are inferred from the source string. Tags travel into every translation, which may move them where the meaning lands. Unbalanced tags: `YAP0041`–`YAP0044`. Vue/Svelte/Astro have their own `<RichText>` from their package; `parseRichText()` in `yapyak` is the raw form.

## Homonyms — `t.as()`

Same English, different meaning:

```ts
t.as('action', 'Open');   // 'Öppna'
t.as('status', 'Open');   // 'Öppen'
```

Context is a short literal label (`action`, `status`, `noun`, `verb`), never shown to users, never a variable (`YAP0017`). It nests in the catalog:

```json
{ "src/components/dialog.tsx": { "Open": { "action": "Öppna", "status": "Öppen" } } }
```

One source cannot be both plain and contextualized in the same file (`YAP0018`). A context used only once is `YAP0019`. Each context counts as its own entry in `status`.

## Locale override — `t.in()`

```ts
t.in('sv', 'Welcome back');
t.in('sv').as('action', 'Open');
t.as('action').in('sv', 'Open');
```

Forces one locale for one call, typed against your `Locale` union. Chains must be completed inline. An invalid BCP 47 tag falls back to `defaultLocale` with `YAP0030`.

## Formatting outside messages

```ts
import { format } from 'yapyak';

format.number(199, { style: 'currency', currency: 'EUR' });  // '€199.00' / '199,00 €'
format.dateTime(new Date(), { dateStyle: 'long' });
format.list(['apple', 'pear', 'orange']);
format.relativeTime(-1, 'day');
format.in('sv').number(199);
```

Thin typed wrappers over `Intl.NumberFormat`, `Intl.DateTimeFormat`, `Intl.ListFormat`, `Intl.RelativeTimeFormat`, reading the active locale. `currency` is required when `style: 'currency'` and autocompletes ISO 4217. Unknown currency/unit/timeZone degrades gracefully with `YAP0035`/`YAP0036`/`YAP0037`/`YAP0054` instead of throwing.

## Reading and switching the locale

Framework binding first — it subscribes the component and is SSR-correct:

```tsx
const [locale, setLocale] = useLocale();          // @yapyak/react
```
```ts
import { locale } from '@yapyak/vue';             // Ref<Locale>, assign to switch
import { locale } from '@yapyak/svelte';          // locale.current, runes
```

Astro switches by navigation (middleware reads the URL); use a framework binding inside an island for client-side switching.

Raw store, for switchers outside a component:

```ts
import { defaultLocale, getLocale, locales, setLocale } from 'yapyak';
```

`locales` is every `<tag>.json` in `localesDir`. Also `getLocaleFallbackChain()`, `getTextDirection()`, `parseLocale()`, `isLocale()`, `isCurrency()`.

Server-side `setLocale()` caveats: outside a `withResponse` scope no cookie is set (`YAP0023`); with `local-storage` it is browser-only (`YAP0024`); with `url` the URL is the source of truth (`YAP0026`); an unknown locale is ignored (`YAP0028`).

## Catalog shape

```json
{
  "src/components/save-button.tsx": {
    "Save changes": "Spara ändringar",
    "Open": { "action": "Öppna" }
  }
}
```

Nested under the owning source file — that path key is how yapyak follows a moved or renamed file. Plain JSON, hand-editable (HMR picks up an edit immediately), but the extractor owns the keys. Empty string = untranslated stub; the source string renders instead.
