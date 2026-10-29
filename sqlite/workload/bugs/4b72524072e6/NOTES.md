repro.sql runs the rowvalue-14.x queries from the fix: vector BETWEEN and CASE
with constant row-value components, plus a table-driven BETWEEN.

Clean shell prints 1, 1, 1, 1 and exits 0. The buggy shell hits
`Assertion memIsValid(&aMem[pOp->p3])` in sqlite3VdbeExec and aborts (-6).
The buggy build codes the vector components with sqlite3ExprCode instead of
sqlite3ExprCodeFactorable, so constant components are not hoisted out of loops.
