# Rationale
One hunk, `tree/src/services/utilities.ts` `createTextSpanFromStringLiteralLikeContent`: for an unterminated string, replacementEnd = `node.getEnd()` instead of `Math.min(position, node.getEnd())`. This matches the fix.diff hunk that introduced the `Math.min` clamp (the other fix hunks only thread `position` through, which is still present as an unused-by-behaviour parameter). Completion replacement spans again swallow comments/code after an unterminated string.

SUMMARY: 2/2 oracle cases failing (1 fix-added).
