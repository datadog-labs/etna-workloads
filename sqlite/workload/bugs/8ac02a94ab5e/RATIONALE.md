# Rationale

Fix hunk reversed: `src/expr.c` sqlite3ExprCompare() added `if( pA->op2!=pB->op2 ) return 2;`
so that `y IS TRUE` and `y IS NOT TRUE` (both TK_TRUTH, differing only in op2) are not equal.
In 3.54.1 the check is spelled `if( pA->op2!=pB->op2 && pA->op==TK_TRUTH ) return 2;`; I deleted that line.
(The sqliteInt.h hunk is a comment only.)

Failing oracle case: index7-7.1 — with partial index `WHERE y IS NOT TRUE`, the query
`WHERE y IS TRUE` wrongly uses the index (terms considered equal) and returns `0 0` instead of `1 1`.
