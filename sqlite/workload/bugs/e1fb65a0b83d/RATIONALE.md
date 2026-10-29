# Rationale

Fix (ticket #3771) added `sqlite3CodeVerifySchema()` and `sqlite3TableLock()` for the RHS table
at the top of the `isCandidateForInOpt()` block in `sqlite3FindInIndex()`, so that
`x IN (SELECT c FROM t)` always gets OP_Transaction/VerifyCookie/TableLock for `t`.

## Change (src/expr.c, sqlite3FindInIndex)
Removed the `sqlite3CodeVerifySchema(pParse, iDb)` and `sqlite3TableLock(...)` calls (and the
now-inaccurate comment). `iDb` is still computed because later code uses it. This restores the
pre-fix behaviour in which the schema cookie check and table lock were not coded for the RHS
table when an existing index is used for the IN operator.

## Oracle failure
`select1-14.2` aborts with `Assertion 'DbMaskTest(p->btreeMask, p1)' failed` in sqlite3VdbeExec
(the OP_OpenRead of the index runs without the transaction being started on that database), which is
the select1-15.x scenario's failure mode (no transaction/cookie verification for the IN index scan).
Subsequent cases in select1.test do not run because of the abort.
