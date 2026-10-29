# Rationale

Fix hunk (src/parse.y, `seltablist ::= stl_prefix LP seltablist RP as on_using`): added
`pNew->pSelect = pOld->pSelect; pOld->pSelect = 0;` so a subquery inside extra parentheses
is moved to the new FROM-clause entry.

In 3.54.1 the subquery lives in `u4.pSubq` plus `fg.isSubquery`. I changed the
`if( pOld->fg.isSubquery )` branch in src/parse.y to no longer transfer it
(removed the `pNew->fg.isSubquery`, `pNew->u4.pSubq` move, clearing of pOld, and the
isNestedFrom propagation). The subquery is then deleted with `F`, and the new entry has no
table name and no subquery, which is the pre-fix behaviour.

## Oracle failures
where8-3.21.2 (`FROM t1, ((SELECT * FROM t2)) AS t3`) fails with an assertion in
selectExpander: `pFrom->fg.isSubquery && pFrom->u4.pSubq!=0`. where8-3.23 would fail
likewise; the run aborts at 3.21.2.
