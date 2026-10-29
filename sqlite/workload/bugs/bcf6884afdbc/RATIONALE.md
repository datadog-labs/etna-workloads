# Rationale

The fix made two changes: it dropped the earlier `&& j>0` workaround in whereScanInit(), and it added WHERE_SEEK_TABLE so DELETE never defers the main-table seek. Version-3.54.1 has no WHERE_SEEK_TABLE. Its equivalent is the `OP_FinishSeek` that DELETE emits after a deferred seek, so I reverted both pieces.

1. `src/where.c` whereScanInit(): restored the pre-fix condition `iColumn==iPKey && j>0`. This reverses the fix hunk in where.c.
2. `src/delete.c`: removed the `if( sqlite3WhereUsesDeferredSeek(pWInfo) ) OP_FinishSeek` block. This is the modern form of the fix's WHERE_SEEK_TABLE flag in delete.c and wherecode.c. Without it, DELETE can read the table cursor while a deferred seek is still pending.

Oracle result: test/intpkey.test intpkey-17.1 crashes with `Assertion 'pC->deferredMoveto==0' failed` in sqlite3VdbeExec. That is the case the fix added. `DELETE ... WHERE abs(x) IS NULL OR abs(x)<130` runs with an index on abs(x) over an IPK table.

The `j>0` change alone failed no oracle case. The failure comes from the delete.c change.
