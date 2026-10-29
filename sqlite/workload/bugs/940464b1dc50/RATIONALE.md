# Rationale

Changed `tree/src/pragma.c` (PRAGMA foreign_key_check codegen): the "report an FK
violation" block again unconditionally emits `OP_Rowid` into `regResult+1`, instead of
`OP_Null` when the child table is WITHOUT ROWID. This reverses the fix's second hunk
(`if( HasRowid(pTab) ) OP_Rowid else OP_Null`). The first hunk (OP_Column ->
sqlite3ExprCodeGetColumnOfTable) was not reverted: the current code already differs
structurally, and the Rowid hunk alone restores the bug.

Failing oracle case: fkey5-10.3 (WITHOUT ROWID child with violating row) hits the assert
`pCur->curIntKey` in sqlite3BtreeIntegerKey, since OP_Rowid is run on a non-intkey cursor
(release builds would return a wrong rowid instead of NULL).
