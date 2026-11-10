# Re-introduced bug: readline cursor can land inside a surrogate pair

Before the fix, left/right (and Ctrl+B / Ctrl+F) moved the readline cursor by exactly one UTF-16
code unit, so with an astral character (e.g. 💻) the cursor could sit between its two surrogates.

## Change (lib/internal/readline/interface.js, 4 one-line hunks in `[kTtyWrite]`)
Corresponds to the fix's `_ttyWrite` hunks (`case 'b'`, `case 'f'`, `case 'left'`, `case 'right'`):
- Ctrl+B and `left`: `kMoveCursor(-charLengthLeft(...))` -> `kMoveCursor(-1)`
- Ctrl+F and `right`: `kMoveCursor(+charLengthAt(...))` -> `kMoveCursor(+1)`
The fix's other hunks (deleteLeft/deleteRight, wordRight regex) are already different in today's code
and were left alone (the helpers are still used by delete).

## Failing test
parallel/test-readline-interface: "not ok"; the astral left/right cases fail with
an assertion `actual: 1, expected: 0` (cursor cols after pressing left on '💻').
