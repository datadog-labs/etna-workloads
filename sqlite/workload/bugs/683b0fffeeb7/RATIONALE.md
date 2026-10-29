# Rationale

The fix added `else{ n++; }` to `groupConcatInverse` so that the 1-argument
form counted the implicit "," separator when removing a row from the window.
In 3.54.1 this logic was redesigned: the inverse adds `pGCC->nFirstSepLength`
(set in `groupConcatStep`) when no varying separator lengths are tracked.
For 1-arg `group_concat(x)`, `groupConcatStep` set `nFirstSepLength = 1` on the first term.

Change (src/func.c, groupConcatStep): removed that `else{ pGCC->nFirstSepLength = 1; }`
block. The 1-arg inverse then again does not account for the "," separator
(nVS = bytes of value only), the same defect as the pre-fix code.

Oracle failure: window6-9.0 (`group_concat(x) OVER (ORDER BY x ROWS 2 PRECEDING)`)
returns wrong output because stale separator characters remain after removal.
