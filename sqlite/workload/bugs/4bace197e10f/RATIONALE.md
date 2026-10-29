# Rationale

Fix reversed: dan's "Fix the cases in joinI.test" (2025-08-23), which replaced the
flat, cursor-number-only ON-clause walk with a context-aware walk (CheckOnCtx).

## Change (src/select.c, `selectCheckOnClausesExpr`)

Fix hunk reversed: the new `selectCheckOnClausesExpr`. It sets `iJoin` when it
reaches the root of an ON term and looks up the SrcList that owns each column.
It then compares against that SrcList. 3.54.1 has since extended this
(position-based comparison, `bFuncArg`, `iJoin<0`). I put back the pre-fix
callback body:

* test every TK_COLUMN carrying EP_OuterON/EP_InnerON on its own;
* error if `pExpr->w.iJoin < pExpr->iTable`, when the term is an OuterON term or
  the FROM clause has a RIGHT/FULL join (the old `w.eCode`, now `hasRightJoin(pCtx->pSrc)`).

The old callback has no per-SrcList context. It compares raw cursor numbers, so
it never checks which FROM clause a column belongs to. The CheckOnCtx
walker, the xSelect callback and the table-function loop are left as they were.
They are the plumbing the fix added, and the table-function code was added later.
Only the decision logic reverts.

## Oracle cases that now fail (./check.sh)

joinI-1.1.2, joinI-3.4 and joinI-4.1. For example, joinI-4.1 expects
`1 {ON clause references tables to its right}` and gets `0 {}`. The ON-clause
check misses references to the right that the context-aware walk finds,
for columns that belong to a different SrcList than the one holding the ON clause.
