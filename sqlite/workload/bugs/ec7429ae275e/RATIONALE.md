# Rationale

Fix (CVS 2747, ticket #1473) made LIMIT handling uniform: the LIMIT counter
is tested after each output row, and a compound `UNION ALL` skips its right-hand
arm once the LIMIT is already exhausted (`OP_IfMemZero` / "Jump ahead if LIMIT
reached", in the `TK_ALL` case of multiSelect). Scalar subqueries and EXISTS rely
on this by being given `LIMIT 1`.

Most of the fix is still present in 3.54.1 (selectInnerLoop's `OP_DecrJumpZero`,
SRT_Exists "LIMIT clause will terminate the loop", `LIMIT 1` in
sqlite3CodeSubselect). The hunk that is not covered elsewhere is the UNION ALL one.

## Change (src/select.c, multiSelect, TK_ALL / no ORDER BY case)
Removed the `OP_IfNot p->iLimit` ("Jump ahead if LIMIT reached") emitted before
the right-hand SELECT. This reverses fix hunk
`+ addr = sqlite3VdbeAddOp(v, OP_IfMemZero, p->iLimit, 0);` and its
`sqlite3VdbeJumpHere`. `addr` stays 0, so the later `if( addr )` is a no-op.
OP_IfNot on the counter is the modern equivalent of OP_IfMemZero. Without it, the
right arm runs with an exhausted counter (0), the first row decrements it to -1,
and it never reaches zero again, so the LIMIT is not enforced.

## Oracle failures
tkt1473-2.4, 2.5, 4.3, 4.4 (scalar subquery / EXISTS over UNION ALL, where the
right arm contributes a row after the left already satisfied LIMIT 1) return the
wrong value. where.test is unaffected.
