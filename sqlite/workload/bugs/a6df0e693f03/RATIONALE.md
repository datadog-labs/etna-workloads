# Rationale

Fix hunk reversed: `src/delete.c` (the truncate optimization in `sqlite3DeleteFrom`).
The fix added `sqlite3VdbeChangeP3(v, -1, memCnt ? memCnt : -1)` for the PRIMARY KEY
index of a WITHOUT ROWID table, so OP_Clear reports the row count. In 3.54.1 this
appears as a branch that emits `OP_Clear` with P3=memCnt for
`IsPrimaryKeyIndex(pIdx) && !HasRowid(pTab)`. I removed that branch, so every index
(including the WITHOUT ROWID PK, which holds the table's rows) is cleared with P3=0
via `sqlite3VdbeAddOp2(v, OP_Clear, pIdx->tnum, iDb)`. This is the pre-fix behavior.

The btree.c/vdbe.c hunks need no reversal. In 3.54.1 `clearDatabasePage` and OP_Clear
already take the count unconditionally, and the P3 flag alone controls whether it is used.

Oracle failure: `delete4-3.0.2`. `DELETE FROM t1` on a WITHOUT ROWID table (no WHERE)
reports changes()==0 instead of 101.
