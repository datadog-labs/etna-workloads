# Rationale

Fix: dan, 2018-06-11, "Fix handling of window frames containing negative number of rows"
(`ROWS x PRECEDING AND y PRECEDING` with x<y, and the FOLLOWING analogue). The fix added,
in windowCodeRowExprStep(), a check (OP_Ge / OP_Le on regStart,regEnd) that treats the frame
as always empty when the bounds are inverted. The src/resolve.c hunk (misuse-of-window-function
messages) is unrelated to the window4 oracle and was not touched.

## Change (src/window.c, sqlite3WindowCodeStep)
windowCodeRowExprStep() no longer exists in 3.54.1. Its equivalent is the block in
sqlite3WindowCodeStep() guarded by
`eFrmType!=TK_RANGE && eStart==eEnd && regStart`, which compares regStart/regEnd
(OP_Ge for FOLLOWING, OP_Le for PRECEDING), emits an empty-frame row via windowAggFinal /
windowReturnOneRow, and jumps to lblWhereEnd. This is the same defect-guard as both added
fix hunks (the `regEnd<regStart` FOLLOWING check and the `regStart<=regEnd` PRECEDING check).
I removed that block, restoring the pre-fix state where inverted ROWS frames are not detected.
The following `OP_Subtract regStart, regEnd` for FOLLOWING is kept, so it yields a negative
count when start>end, as before the fix.

## Oracle failures
test/window4.test: 109 of 224 cases fail, including 3.6.1 (`ROWS BETWEEN 2 FOLLOWING AND 1
FOLLOWING`); the run then aborts with an assertion failure in sqlite3VdbeExec at 4.5.36.2
(incomplete run), so later cases (4.5.37+, 10.x, 11.x, 12.x) also fail. window1 is unaffected.
