repro.sql runs `overlay` edge cases from the fix's functions.slt: start past the end, start 0, and multibyte Unicode input.

- df-clean: `overlay('abc' placing 'X' from 5 for 1)` gives `abcX`, start 0 gives the "negative substring length not allowed" error, and the Unicode cases return `aéXc` and `αβXY`.
- df-buggy: the first query returns `X`, start 0 gives a different error message, and `overlay('aébc' ...)` panics on a non-char-boundary slice (exit 101).
