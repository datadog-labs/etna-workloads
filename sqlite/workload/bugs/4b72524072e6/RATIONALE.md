# Rationale

Fix: in `exprCodeVector()` the components of a vector are coded with
`sqlite3ExprCodeFactorable()` instead of `sqlite3ExprCode()`, so that constant
vector components are evaluated outside loops in CASE and BETWEEN.

## Changes (tree/src/expr.c)

1. `exprCodeVector()`: `sqlite3ExprCodeFactorable(...)` -> `sqlite3ExprCode(...)`.
   Direct reversal of the fix hunk.
2. `exprNodeIsConstant()`: removed `case TK_REGISTER` from the "not constant"
   list. In 3.54.1 this independently covers the same case: CASE/BETWEEN
   convert the LHS vector to TK_REGISTER nodes, and a TK_REGISTER is treated as
   non-constant, so the comparison is never factored out of the loop even when
   the vector registers are only filled in-loop. In 2016 TK_REGISTER was
   considered constant, so with hunk 1 alone the comparison `(2,2) >= (1,1)`
   was hoisted to the init section and read registers that were only
   initialised in the loop body. Hunk 1 alone does not reproduce the bug.

## Oracle failures

rowvalue-14.1 (`SELECT 1 WHERE (2,2) BETWEEN (1,1) AND (3,3)`) hits the
assertion `memIsValid(&aMem[pOp->p3])` in sqlite3VdbeExec (uninitialised
register read); the run aborts there, so later cases (14.2-14.6) do not run.
