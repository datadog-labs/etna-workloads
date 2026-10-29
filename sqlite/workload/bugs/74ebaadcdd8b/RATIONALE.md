# Rationale

Fix: for a LEFT JOIN, the IN-loop end code must not run OP_Next/OP_Prev (or OP_IfNoHope)
on the IN cursor when that cursor was never opened / is a null row (the `a=? AND b IN(...)`
case where the `a=?` term is NULL). The fix added OP_IfNotOpen in sqlite3WhereEnd.

In 3.54.1 the same guard exists as the `if( pLevel->iLeftJoin ){ ... OP_IfNullRow ... }`
block in sqlite3WhereEnd (src/where.c), which replaced OP_IfNotOpen. I removed that block
(only that), which restores the pre-fix behaviour: the LEFT JOIN guard before
OP_IfNoHope/OP_Next is missing. The `bEarlyOut` logic and wherecode.c are untouched.
(The vdbe.c hunk was only a comment/opcode addition; the opcode is gone, nothing to revert.)

Oracle failure: in4-7.1 (`SELECT * FROM t2 LEFT JOIN t1 ON c = d AND b IN (10,10,10)`)
aborts with `Assertion pC->eCurType==CURTYPE_BTREE failed` in sqlite3VdbeExec (OP_IfNoHope
on the null-row cursor); the run stops there so later cases do not run.
