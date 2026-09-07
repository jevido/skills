# Diagnostics

Compile-time and runtime diagnostics, surfaced in the editor and the terminal. Long form: `https://yapyak.dev/reference/diagnostics/YAP0001.md` (swap the code).

Rough grouping: 0001–0006 call-site extraction · 0007–0012 ICU structure · 0013–0016, 0031, 0039, 0047 locale files · 0017–0020 `t.as` / `t.in` · 0021 plugin wiring · 0022–0029 locale store & SSR · 0030 bad tag · 0032 cache · 0033–0034 translator runs · 0035–0037, 0054 `Intl` fallbacks · 0038, 0045–0046, 0050–0052 branches & placeholders · 0040 reactivity trackers · 0041–0044 rich-text tags · 0048 processor parse · 0049, 0051 near-miss names · 0053 orphan entry · 0055 module-scope `t()`.

| Code | Meaning |
| --- | --- |
| `YAP0001` | `t()` or `t.as()` is called without a source string. |
| `YAP0002` | The compiler can't extract a source string built from a template literal. |
| `YAP0003` | `t()` is called with an empty string as the source. |
| `YAP0004` | The source references a placeholder that isn't in the params object. |
| `YAP0005` | The params object has a key the source string doesn't reference. |
| `YAP0006` | The compiler can't read params unless they're an inline object literal. |
| `YAP0007` | An ICU placeholder has unparseable syntax: mismatched braces, empty branches, or broken structure. |
| `YAP0008` | An ICU `plural`, `selectordinal`, or `select` placeholder is missing the required `other` branch. |
| `YAP0009` | An ICU feature is used that yapyak doesn't support. Common cases: plural offsets, custom number skeletons, apostrophe escaping in some forms. |
| `YAP0010` | A translation changes a placeholder's format kind (e.g., `plural` to `select`). The structure must match between source and translation. |
| `YAP0011` | A placeholder in the source string is missing from the translation. |
| `YAP0012` | A placeholder appears in the translation but isn't in the source string. The mirror case of `YAP0011`, usually a hand-edit slip. |
| `YAP0013` | A locale entry doesn't match the expected shape. Each entry must be a string or a context-keyed object of strings. |
| `YAP0014` | A locale file-path key contains `..`, a Windows-style backslash, or is absolute. Path keys are normally derived from source-file locations by the extractor, so this almost always means something other than yapyak wrote the entry. |
| `YAP0015` | A source string isn't in Unicode NFC form. yapyak normalizes during extraction, so this only fires when a key has been hand-edited into a non-canonical form. |
| `YAP0016` | A locale file isn't valid JSON. The detail message includes the parser error and position. |
| `YAP0017` | The first argument to `t.as()` must be a static string literal. |
| `YAP0018` | A source string can't be used with both `t()` and `t.as()` in the same file. |
| `YAP0019` | `t.as()` only makes sense when the same source is used with another context. If `'Open'` has only one context, the disambiguation is unused. |
| `YAP0020` | The chain forms `t.as(...)` and `t.in(...)` must be called inline so the compiler can extract the source. |
| `YAP0021` | The yapyak runtime is loaded but the build-tool plugin isn't registered. |
| `YAP0022` | `getLocale()` falls back to the shared module-global locale during SSR. Concurrent requests may see each other's locale. |
| `YAP0023` | `setLocale()` runs on the server outside a `withResponse` scope. The cookie isn't set. |
| `YAP0024` | `setLocale()` runs on the server with `persistence: 'local-storage'`. Local storage is browser-only. |
| `YAP0025` | `setLocale()` can't write to `localStorage`. Common causes: quota exceeded, Safari private mode, or storage disabled by the user. |
| `YAP0026` | `setLocale()` runs with `persistence: 'url'`. The URL is the source of truth for the locale in this configuration. |
| `YAP0027` | A locale-change subscriber throws an exception during a locale switch. yapyak continues with the remaining subscribers. |
| `YAP0028` | `setLocale()` is called with a value that isn't one of your configured locales. The call is ignored. |
| `YAP0029` | `setLocale()` runs on the server in a way that leaks across concurrent requests. |
| `YAP0030` | `t.in('xx', 'source')` is called with a tag that isn't a valid BCP 47 locale. yapyak falls back to your `defaultLocale`. |
| `YAP0031` | A locale file is structurally damaged in a way `YAP0016` doesn't cover. Usually a partial write or filesystem issue. |
| `YAP0032` | The `.yapyak/` cache is damaged. |
| `YAP0033` | A batch chunk fails after retries during a translator run. yapyak keeps the other chunks and returns partial results. |
| `YAP0034` | A custom translator returns something other than an object keyed by target locales for one entry. The entry is dropped and the translations are empty. |
| `YAP0035` | `format.number(..., { currency: 'XXX' })` is called with a currency code your `Intl` runtime doesn't know. yapyak renders the value as `<value> XXX` instead of failing. |
| `YAP0036` | `format.number(..., { unit: '...' })` is called with a unit your `Intl` runtime doesn't know. yapyak renders the value as `<value> <unit>` instead of failing. |
| `YAP0037` | `format.dateTime(..., { timeZone: '...' })` is called with a zone your `Intl` runtime doesn't know. yapyak renders the date in the system time zone. |
| `YAP0038` | A translation omits a plural or select branch that the source defines. |
| `YAP0039` | Migrating a locale file from an older yapyak format to a newer one fails for one locale. yapyak skips it and continues with the others. |
| `YAP0040` | A reactivity tracker auto-registered by framework bindings throws during a re-render. yapyak continues with the remaining trackers. |
| `YAP0041` | An opening tag in the source has no matching closing tag. |
| `YAP0042` | A closing tag's name doesn't match the most recent opening tag. |
| `YAP0043` | A closing tag has no preceding opening tag. |
| `YAP0044` | A tag has empty brackets and no name. |
| `YAP0045` | A `plural` or `selectordinal` branch in the translation uses a name that is neither a plural category of the target locale nor an exact match like `=1`. |
| `YAP0046` | A `plural` or `selectordinal` branch in the source uses a name that is not a CLDR plural keyword and not an exact match like `=1`. |
| `YAP0047` | A locale file is not readable. The file exists, but the filesystem denies the read, usually because of file permissions or an exhausted open-file limit. |
| `YAP0048` | A framework processor's parser could not read the source file, so its `t()` calls cannot be extracted. The message and range come from the parser itself. |
| `YAP0049` | A key in the params object matches no placeholder, and one placeholder is close enough to it to be the intended name. |
| `YAP0050` | The translation of a source string has broken ICU syntax, so its placeholders cannot be read. |
| `YAP0051` | A placeholder in the translation matches no placeholder in the source, and one source placeholder is close enough to it to be the intended name. |
| `YAP0052` | A placeholder name holds a character ICU does not allow, or starts with a digit. |
| `YAP0053` | A locale file holds a translation for a source string that no `t()` call in that file uses any more. |
| `YAP0054` | A `currency` style names a code the platform cannot format. |
| `YAP0055` | A `t()` call sits at module scope, so it evaluates once when the module loads. The result never updates when the active locale changes, and on the server it is shared across requests. |
