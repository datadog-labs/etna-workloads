# Rationale

## Changed hunk: `termIsEquivalence()` in `tree/src/whereexpr.c`

The fix added condition (4) to `termIsEquivalence()`. It returns 0 for a
`TK_IS` term when the leftmost FROM-clause entry has `JT_LTORJ`, which means
the query contains a RIGHT JOIN. In 3.54.1 that condition is written as
`pExpr->op==TK_IS && pSrc->nSrc>=2 && (pSrc->a[0].fg.jointype & JT_LTORJ)!=0`.
The `nSrc>=2` guard is a later refinement. I removed the whole check, so IS
terms are treated as transitive equivalences even in RIGHT JOIN queries.
That is the pre-fix behaviour. The `pSrc` parameter and the call site
already existed, so nothing else changed.

## Oracle failure

`join-32.2` in test/join.test fails. It expected `NULL NULL 123 NULL` and got
an empty result. The query is `t0 JOIN v0 ON w=z RIGHT JOIN t1 ON true INNER
JOIN t2 ON y IS z`, and the wrong transitive substitution of IS drops the row.
`join-32.3` still passes because `+y` is not an indexable column.
