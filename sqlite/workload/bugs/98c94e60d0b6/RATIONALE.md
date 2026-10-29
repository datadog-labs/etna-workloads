# Rationale

Fix (ticket b47e3627ecaadbde): `exprCommute()` in src/whereexpr.c must flip
`EP_Commuted` whenever either operand is a TK_VECTOR, because the
collation-difference test alone cannot tell that the operands' collations
were swapped.

## Changes
1. `src/whereexpr.c` `exprCommute()`: removed the
   `pLeft->op==TK_VECTOR || pRight->op==TK_VECTOR` clause (the fix's only
   implementation hunk, reversed verbatim). Alone this no longer reproduces the
   bug: `sqlite3ExprCollSeq()` now looks through TK_VECTOR to its first element,
   so the two `sqlite3BinaryCompareCollSeq()` calls usually differ anyway.
2. `src/expr.c` `sqlite3ExprCollSeq()`: dropped `op==TK_VECTOR` from the
   "look at first list element" case (kept for the TK_FUNCTION case). This
   restores the old state where a vector had no collation of its own, so both
   `BinaryCompareCollSeq` calls in `exprCommute` agree and, without hunk 1's
   check, `EP_Commuted` is not set when the vector terms are swapped. This is
   the "other path covering the same case" that made hunk 1 alone ineffective.

## Oracle failures
`rowvalue-23.100` fails: `(+bb,1) >= (aa,1)` with `aa COLLATE NOCASE` in the
WHERE clause is commuted without the flag, so the wrong collation is used for the
comparison and the row is returned/omitted incorrectly (expected `0 1 3`).
(rowvalue-23.110/23.120 still pass.)
