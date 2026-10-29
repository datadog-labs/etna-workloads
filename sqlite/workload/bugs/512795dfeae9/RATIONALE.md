# Rationale

Fix: `sqlite3EndTable()` got `if( pParse->nErr ) return;` before calling
`sqlite3ResultSetOfSelect()`, so `CREATE TABLE t AS SELECT #0` (a syntax error
that still leaves a Select behind) no longer dereferences NULL.

In 3.54.1 the same defect is covered by two guards, so both are reverted:

1. `src/build.c` (sqlite3EndTable, CREATE TABLE AS branch): removed
   `if( pParse->nErr ) return;` after `OP_InitCoroutine` — exactly the line the
   fix added.
2. `src/select.c` (sqlite3ResultSetOfSelect): removed
   `if( pParse->nErr ) return 0;` after `sqlite3SelectPrep()`. This later guard
   makes the build.c check redundant; without it, an unresolved Select with
   errors flows into `sqlite3ColumnsFromExprList`/`sqlite3SubqueryColumnTypes`,
   as in the original bug (the pre-fix ResultSetOfSelect had no nErr check).

Failing oracle case: `colname-9.400` (`CREATE TABLE t4 AS SELECT #0;`) aborts with
`Assertion (pSelect->selFlags & SF_Resolved)!=0 failed` in
`sqlite3SubqueryColumnTypes` (a crash/NULL-deref in non-assert builds).
