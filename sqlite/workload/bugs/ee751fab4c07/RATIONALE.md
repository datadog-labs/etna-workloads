# Rationale

Fix: `VACUUM INTO <identifier>` must raise "no such column", by calling
`sqlite3ResolveSelfReference(pParse,0,0,pInto,0)` before coding the expression.
In 3.54.1 the function already has the new signature (returns int, pTab may be
NULL), so only the call site in `sqlite3Vacuum` (src/vacuum.c) was reverted:
`if( pInto && sqlite3ResolveSelfReference(...)==0 )` -> `if( pInto )`.
This restores the pre-fix behaviour: the unresolved TK_ID expression is passed
straight to sqlite3ExprCode.

Oracle: vacuum-into-320 (`VACUUM INTO x`) hits the assertion
`op==TK_NULL || op==TK_ERROR || mallocFailed` in sqlite3ExprCodeTarget
(debug build), aborting the run; 320 and all later cases fail.
