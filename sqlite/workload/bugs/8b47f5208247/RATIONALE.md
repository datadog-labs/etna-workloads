# Rationale

Fix hunk reversed: in `windowCodeRangeTest()`, the BIGNULL block's
`OP_Goto` taken when reg1 is NULL (and the jump to lbl was not taken). The fix
changed its target from `CurrentAddr+2` (lands on the final comparison) to
`CurrentAddr+3` (skips the comparison). Pre-fix, the comparison still ran when
reg1 was NULL.

In 3.54.1 the skip is `OP_Goto -> addrDone`, a label resolved after the final
comparison. `src/window.c` now emits that Goto with a placeholder target
(`addrSkip`) and resolves it with `sqlite3VdbeJumpHere()` just before the
final comparison, so it lands on the comparison as in the old code. The
reg2-NULL `IsNull -> addrDone` path is unchanged (the fix's `ChangeP2` part).

Oracle failure: `window8-4.5.2`
(`ORDER BY a DESC NULLS FIRST RANGE BETWEEN UNBOUNDED PRECEDING AND 10 FOLLOWING`)
gives the wrong result; the other 361 cases pass.
