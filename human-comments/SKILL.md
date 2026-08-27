---
name: human-comments
description: >
  Rewrite a GitHub/Bitbucket issue or PR comment (or any prose reply) so it reads
  as human-written instead of AI-generated. Strips the mechanical tells of LLM prose
  — em-dashes, bold-lead bullet lists, section headers inside a comment, checkmark
  emoji, hedge-and-recommend tics, reassurance openers, antithesis constructions,
  and closing pleasantries — while keeping every technical point intact. Use this
  skill whenever the user says "humanize this comment", "make this sound human",
  "de-claude this", "de-slop this", "does this sound like AI", "/human-comment", or
  asks to write/rewrite an issue or PR comment in their own voice — even if they
  don't use these exact words.
---

# Human Comments

Rewrites a draft comment so it stops reading as AI-generated. The goal is not to
dumb it down — keep the argument, the technical detail, and the structure of the
reasoning. Remove only the surface patterns that mark text as machine-written.

Grounded in a real analysis of the `allunited-nl/mono` issue comments (3694 comment
blocks): the counts below are the actual per-tell frequencies found there, ordered
by how loud a signal each is.

## When Invoked

The user either pastes a draft, points at an existing comment (URL / issue number),
or is about to post one. Do this:

1. **Get the draft.** If they gave a GitHub URL or `#123`, fetch it with
   `gh issue view` / `gh api .../comments`. Otherwise use the pasted text.
2. **Run the de-slop pass** (checklist below) — rewrite, don't annotate in place.
3. **Output the rewritten comment** in a single fenced block, ready to paste.
4. **Below it**, list the specific edits made as short bullets: `tell → fix`. Keep
   this to what actually changed; skip tells that weren't present.
5. Never invent technical claims, soften a firm position into mush, or drop a point
   to make the rewrite shorter. Same substance, human surface.

If the draft is already clean, say so and change nothing rather than manufacturing edits.

## The Tells (strongest signal first)

### Structural — fix these first, they carry the most signal

Markdown itself is fine and welcome. The tell is *reflexive* markdown — structure
applied because the model always structures, not because the content asked for it.
The test for every list, header, or bold span: would a person bother, for this
content, in a comment? If yes, keep it. If it's decoration, cut it.

- **Em-dash `—`** (1006 hits). The single loudest fingerprint, and it's not markdown,
  it's punctuation. Replace with a period, comma, colon, or parentheses. A human
  writing a quick comment reaches for `-` or just splits the sentence. Kill nearly
  all of them.
- **Bold-lead bullets `- **Thing**: explanation`** (271). The specific tell is the
  *pattern applied to everything* — every point forced into `**Label**: sentence`.
  Genuine enumerated options or a real checklist can stay as a list. Prose that got
  chopped into labelled bullets should go back to prose. Keep the bullets that earn
  it; unwind the ones that were just formatting.
- **`##` / `###` headers inside a short reply** (201). A two-paragraph comment doesn't
  need sections. Fold those into a sentence or a lead-in phrase. Headers are fine in a
  long proposal or a multi-part answer where they're real navigation, not sprinkled
  on a reply.
- **✅ / ❌ / 🚀 emoji as markers** (24 / 3). Delete. State it in words.
- **Triads** — "fast, reliable, and scalable". Cut to one or two, or rephrase.

### Phrase tics — the verbal fingerprints

- **"That said,"** (11) — as a paragraph pivot. Use "But", "Though", or just start
  the sentence. Once per comment at most; never twice.
- **"Concretely," / "So, concretely:"** (9) — very AI. Just give the concrete thing.
- **"To be clear,"** (7) — usually deletable; say the clear thing.
- **"I'd lean toward…"** (6) — the hedged recommendation. Fine occasionally, but if
  it appears more than once, commit: "I'd do X" / "I think X".
- **"Note that" / "It's worth noting"** (5 / 4) — drop the frame, keep the fact.
- **"Good catch" / "You're right" / "Makes sense"** (5 / 3 / 2) — reassurance opener
  before engaging. Skip it and respond to the point directly.
- **"Feel free to…" / "Happy to…" / "Let me know…"** (12 / 5) — closing pleasantries.
  A human ends on the last real point. Cut the wind-down.
- **"Not X — it's Y" / "isn't X, but rather Y"** antithesis (15). Rephrase as a plain
  statement of what it *is*.
- Also watch: "essentially", "in practice", "in essence", "at the end of the day",
  "overall", "the key insight/point", "under the hood", "out of the box".

## Positive Direction — what human comments actually do

- Open on the point, not a compliment or a preamble.
- Vary sentence length. Real writing has short punchy lines next to long ones.
- Use contractions. Some lowercase. Occasional fragment.
- Reference people and prior comments directly (`@handle`, "your point about X").
- Commit to a position instead of laying out a balanced menu. Opinions read human;
  exhaustive fairness reads generated.
- Let it be a little uneven. Perfectly parallel structure is the tell.

## Example

**Before (AI-tell heavy):**

```
Good catch — this is a real concern. That said, I'd lean toward keeping the current
approach for now. Concretely:

- **Simplicity**: fewer moving parts to reason about.
- **Performance**: avoids the extra round-trip.
- **Consistency**: matches the rest of the codebase.

Feel free to let me know if you'd like me to explore alternatives! 🚀
```

**After (human):**

```
I'd keep the current approach for now. It's fewer moving parts, it avoids the extra
round-trip, and it matches what the rest of the codebase already does. If we hit a
real scaling problem we can revisit, but I don't think we're there yet.
```

Same position, same three reasons, no scaffolding. The list wasn't wrong because
it was a list, it was wrong because three short reasons flow fine as a sentence. Had
these been three distinct options to weigh, keeping them as bullets would be the
human choice too.

## Notes

- This skill is about *comments and replies*. Long proposal issues legitimately use
  headers and lists — don't strip those from a genuine spec document.
- If the user wants the rewrite in Dutch or another language, keep the same de-slop
  rules; the tells translate.
