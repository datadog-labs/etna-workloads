# Rationale

Fix hunk (src/where.c, wherePathSolver, WHERE_SORTBYGROUP block): the fix made
the second wherePathSatisfiesOrderBy() call record its reverse mask and
store it in `pWInfo->revMask` when the ORDER BY is satisfied by the GROUP BY
index. Before the fix, the mask went to a throwaway `notUsed` and
`sorted` was set from the result, so ASC/DESC of the ORDER BY terms was ignored.

In 3.54.1 the block (src/where.c ~6246) has the same shape, so I restored the
pre-fix form: `Bitmask notUsed`, pass `&notUsed`, `pWInfo->sorted = (nOrder==nExpr)`,
and no `pWInfo->revMask = revMask`. (The fix's WHERE_GROUPBY clear/restore is not
present in 3.54.1 and was not touched.)

Failing oracle cases (test/tkt-ba7cbfaedc.test): 1.1.4, 1.2.3, 1.3.2, 1.4.1, 2.0.
Rows come out in the wrong direction when ORDER BY direction differs from the
index's (e.g. `GROUP BY id ORDER BY id desc` returns 1 2 3 4 5).
