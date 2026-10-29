# Rationale

Single file changed: `tree/ext/fts5/fts5_aux.c`.

- `fts5HighlightCb()`: reverted the fix's hunk by restoring the pre-fix logic. The
  `bOpen` state machine is gone: the highlight is opened unconditionally at
  `iPos==iter.iStart`, closed unconditionally at `iPos==iter.iEnd`, and the
  `iRangeEnd` block again closes only when `iPos` lies inside the current phrase.
  This is the exact code the fix replaced. With overlapping tokens (trigram) a
  phrase end/start is therefore emitted per token, not coalesced by byte offset.
- `fts5HighlightFunction()` / `fts5SnippetFunction()`: removed the added
  `if( ctx.bOpen ) append zClose` after tokenizing (reverses the fix's two matching hunks).
  The `bOpen` struct field is left in place but is never set.

## Oracle failures
fts5trigram-8.1.2, 8.1.3, 8.3 (highlight() with trigram, e.g. `[abc]de[cde]`
instead of `[abcde]`).
