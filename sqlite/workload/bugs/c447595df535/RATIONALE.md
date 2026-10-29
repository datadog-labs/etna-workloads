# Rationale

Fix hunk reversed: the `where.c` hunk in `whereLoopAddBtreeIndex()`. The fix made
the "WHERE-clause terms may not drive the right table of a LEFT JOIN" check apply
to all operators. Before the fix it applied only to `WO_IS|WO_ISNULL`.

In 3.54.1 that check is `constraintCompatibleWithOuterJoin()`, called from
`whereLoopAddBtreeIndex()` in `src/where.c`. I restored the pre-fix operator
restriction by adding `&& (eOp & (WO_IS|WO_ISNULL))!=0` to the call-site condition.
Other operators, such as `>=` on an indexed expression, can now use WHERE-clause
terms to drive the index on the right table of a LEFT JOIN.

The `select.c` `NEVER()` hunk is an assert-coverage annotation and has no
behavioural effect, so I did not touch it.

## Oracle
`where-20.0` fails. The query is
`SELECT count(*) FROM t201 LEFT JOIN t202 ON (x=y) WHERE ifnull(z,0)>=0`.
It returns a wrong count (not 0), because the index on `ifnull(z,0)` is driven by
a WHERE term. The NULL-extended row is then not filtered. The other 322 cases pass.
