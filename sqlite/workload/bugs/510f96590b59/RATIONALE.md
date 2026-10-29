# Rationale

## Change: tree/src/update.c (sqlite3Update)
Removed `sqlite3VdbeAddOp1(v, OP_MustBeInt, regNewRowid);` after the new rowid
is computed in the `if( chngRowid )` block.

Reverses the fix's only implementation hunk, which added
`OP_MustBeInt regRowid` after `sqlite3ExprCodeAndCache(... pRowidExpr, regRowid)`.
In 3.54.1 the code was restructured (the register is `regNewRowid`, and the
expression may come from OP_Column for UPDATE FROM), but the instruction is the
same one, so removing it restores the pre-fix behaviour: a non-integer value
assigned to an INTEGER PRIMARY KEY is never checked/converted before use.

## Oracle failures
test/trigger1.test trigger1-15.1 (`UPDATE tA SET a='abc'` on a table with a
BEFORE UPDATE trigger) aborts with
`Assertion '(pIn3->flags & MEM_Int)!=0 || pOp->opcode==OP_SeekRowid' failed`
in sqlite3VdbeExec, instead of returning `datatype mismatch`. This is the assert
failure the fix addressed.
