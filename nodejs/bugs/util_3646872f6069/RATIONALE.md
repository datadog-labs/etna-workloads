# Re-introduced bug: DEL (0x7F) not zero width

**Bug.** `isZeroWidthCodePoint` in `lib/internal/util/inspect.js` used `code > 0x7F` for the C1 range, so DEL (ASCII 127) was not treated as a zero-width control character when Node is built without ICU. DEL was counted as width 1.

**Hunk 1** (`isZeroWidthCodePoint`, now ~line 2947): `code >= 0x7F` -> `code > 0x7F`. This is the direct reversal of the fix's only implementation hunk, re-expressed for today's code (the function moved out of the `else` branch).

**Hunk 2** (ICU `getStringWidth` ASCII fast path, ~line 2974): `code >= 127` -> `code > 127`. The release build has ICU, so hunk 1 is only reachable in non-ICU builds and cannot fail the oracle test here. This hunk puts the same DEL boundary error into the ICU fast path: DEL no longer goes to ICU and is counted as 1 via `code >= 32 ? 1 : 0`. It has no counterpart in the upstream fix. It is a deviation I added so the bug can be observed in this ICU build.

**Failing test.** `parallel/test-icu-stringwidth` fails in 2 of 2 runs. The failing assertion is the control-character loop: `getStringWidth('\x7f')` gives `actual: 1, expected: 0`.
