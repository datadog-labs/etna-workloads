# Rationale

Fix hunk reversed: `explainIndexRange` in where.c, which special-cased the
rowid slot at the end of an index entry (`i==pIndex->nColumn ? "rowid" : aCol[aiColumn[i]].zName`).

In 3.54.1 that logic lives in `explainIndexColumnName()` (src/wherecode.c),
whose `if( i==XN_ROWID ) return "rowid";` line I removed. The rowid slot
(aiColumn == XN_ROWID, -1) now indexes `aCol[-1]`, an out-of-bounds read,
which is the crash in EXPLAIN QUERY PLAN that the fix addressed.

The other hunk (the `assert( pIdx->nColumn>=nEq )` -> `strlen(zAff)>=nEq`) is
only an assert fix and already holds in current code (wherecode.c:967), so it
is not reverted.

Oracle: indexedby-11.2 (`WHERE a=1 AND b=1 AND rowid=3` with INDEXED BY, which
uses rowid as an equality term) crashes the testfixture; the run stops there,
so the later 11.x cases do not complete.
