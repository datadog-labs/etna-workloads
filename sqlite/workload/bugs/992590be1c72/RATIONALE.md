# Rationale

Fix: in sqlite3Insert (INSERT ... SELECT), replaced
`assert(pParse->nErr==0||rc); if(rc||mallocFailed) goto cleanup` with
`if(rc||mallocFailed||pParse->nErr) goto cleanup`.

## Changes
1. `src/insert.c` (coroutine branch after `sqlite3Select(pParse, pSelect, &dest)`):
   restored the pre-fix assert and condition, dropping the `pParse->nErr` test.
   This reverses the fix hunk directly.
2. `src/select.c`, end of `multiSelectByMerge()`: `return pParse->nErr!=0;` -> `return 0;`.
   In 3.54.1 this second path also covers the case (the error from an unknown
   collation found in multiSelectCollSeq is reported through the return code, so
   the assert would hold). Pre-fix code returned success here, so the nErr/rc
   mismatch the fix addressed exists again.

## Oracle failure
`insert4-9.1` (`INSERT INTO t1(x) VALUES(5 COLLATE xyzzy) UNION SELECT 0;`) aborts
with `Assertion 'pParse->nErr==0 || rc' failed` in sqlite3Insert (debug build).
