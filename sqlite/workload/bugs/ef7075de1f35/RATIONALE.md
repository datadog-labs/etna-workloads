# Rationale

## Changed hunk
`tree/src/select.c`, in `sqlite3Select()` OP_Count optimization: removed the call
`explainSimpleCount(pParse, pTab, pBest);` after `OP_Close`.

This reverses the fix's only implementation hunk (the added `explainSimpleCount(...)`
call at the OP_Count site). The helper itself was rewritten since 2011 (uses
`sqlite3VdbeExplain`), so the call was removed rather than the helper, which
restores the pre-fix behavior: `EXPLAIN QUERY PLAN SELECT count(*) FROM tbl`
emits no OP_Explain row for the scan.

## Oracle failures
`test/eqp.test` eqp-7.1 (and following 7.x cases): `det 7.1 "SELECT count(*) FROM t1"`
expects `QUERY PLAN / --SCAN t1` but gets no plan row.
