# Ticket #2177: IS NULL index use on the right table of a LEFT JOIN

## Fix hunk reversed
The fix's `bestIndex()` hunk removed WO_ISNULL from the allowed equality
operators when `pSrc->jointype & JT_LEFT`. Without it, an index could satisfy
`y IS NULL` on the right table of a LEFT JOIN. That is wrong, because y can
also be NULL for an unmatched row, and the index cannot see those rows.

In 3.54.1 `bestIndex()` no longer exists. `whereLoopAddBtreeIndex()` in
`src/where.c` now does the equivalent job. It calls
`constraintCompatibleWithOuterJoin()` for terms on outer-join tables, and that
call rejects WHERE-clause terms (non-ON terms). I added `eOp!=WO_ISNULL` to
that condition, so IS NULL terms skip the check. That restores the pre-fix
rule: IS NULL terms may drive an index on a LEFT JOIN right table.

The other two fix hunks are not reverted. One only adds the `eqTermMask`
variable. The other is `codeAllEqualityTerms`, a loop bound and assert
cleanup that does not change behaviour.

## Oracle
`where4-3.2` fails (`SELECT * FROM t2 LEFT JOIN t3 ON a=x WHERE y IS NULL`).
The index on t3(x,y) is used with y IS NULL, so the unmatched row for a=3
is lost or wrong. Every other oracle case passes (1 error out of 42).
