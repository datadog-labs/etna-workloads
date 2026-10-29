# Rationale

Fix hunk reversed: `src/vdbemem.c`, `sqlite3ValueFromExpr()`. The fix wrapped
`valueFromExpr()` and, for REAL affinity with a MEM_Int outside the 6-byte
range, called `sqlite3VdbeMemRealify()`. In 3.54.1 the block was present
(with a slightly different range test), so the fix did not reverse
textually. I removed the whole block, restoring the pre-fix one-liner
`return pExpr ? valueFromExpr(db, pExpr, enc, affinity, ppVal, 0) : 0;`.
Large integer defaults on REAL columns are then stored as integers in
indexes for rows that use the default.

Oracle cases failing in test/default.test:
- 6.3: `WHERE c = 9.2233720368547758e+18` via the index returns `3` instead of `1 2 3`.
- 6.7: the UNIQUE constraint violation is not detected (insert succeeds).
- 6.8: NOT INDEXED count returns 2 instead of 1.
