# Rationale

Fix hunk reversed: src/resolve.c, resolveSelectStep(): the fix changed the
FROM-clause subquery resolution from `sqlite3ResolveSelectNames(pParse, pSub, &sNC)`
to `pOuterNC`, so FROM subqueries cannot see sibling FROM-clause tables of the
enclosing SELECT (ticket #3530).

In 3.54.1 `sNC` is zeroed for LIMIT resolution before the FROM loop, so simply
passing `&sNC` would not restore the old behaviour. The change therefore:
- sets `sNC.pSrcList = p->pSrc; sNC.pNext = pOuterNC;` before the loop (the old
  context of the current SELECT, as the later code sets it again anyway), and
- passes `&sNC` instead of `pOuterNC` to sqlite3ResolveSelectNames() for the
  FROM-clause subquery. The isCorrelated bookkeeping still uses pOuterNC->nRef.

The sqliteInt.h/manifest/test hunks are comments/metadata only.

Oracle: tkt3346-2.1 fails. `SELECT * FROM (SELECT * FROM t1 WHERE 1=x.a) AS x`
returns `1 alice` instead of `no such column: x.a`. Cases 1.1-1.4 still pass.
