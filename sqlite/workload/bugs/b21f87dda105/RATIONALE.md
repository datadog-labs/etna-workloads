# Rationale

Fix hunk (src/vdbeapi.c, columnMem): replaced the check `i>=vals || i<0`
with a validity check that also covers a statement with no current result row
(`pVm==0 || resOnStack==0 || i>=nResColumn`), so column accessors called after
sqlite3_reset() return NULL instead of crashing (ticket #2426).

In 3.54.1 the equivalent guard is `pVm->pResultRow!=0` in columnMem()
(src/vdbeapi.c). sqlite3_reset clears pResultRow (vdbeaux.c), so I removed that
term: the condition is now `i<pVm->nResColumn && i>=0`. After reset, nResColumn
is still nonzero, so columnMem returns `&NULL[i]`, a null Mem pointer.

Failing oracle: capi3-17.2 (column_int after reset) aborts with
`Assertion 'pMem!=0' failed` in sqlite3VdbeIntValue (a segfault without asserts).
Later cases in capi3.test don't run because the process aborts.
