# Rationale
Both edits are in `tree/src/services/utilities.ts` and correspond to the fix's two hunks.

1. `findLinkNameEnd`: I removed the early `://` branch. The fix added that branch, so removing it restores the old behaviour. A link whose text starts with `://` (for example `{@link https://x|text}`) no longer ends the name at the `|`, and the bar leaks into the display text.
2. `buildLinkParts`: this corresponds to the fix's change to the separator expression, which dropped `text.indexOf("://") === 0`. The old code kept that check, so I put it back in today's `separator` condition. A `://`-prefixed link text now gets no extra space, as before the fix.

Final ./check.sh summary: SUMMARY: 2/2 oracle cases failing (1 fix-added).
