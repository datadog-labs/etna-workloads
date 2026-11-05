# Rationale
Hunk: src/backend/optimizer/util/clauses.c, make_SAOP_expr() (array-building loop).
Traces to fix.patch hunk in match_orclause_to_indexcol() that changed
`Assert(!value->constisnull && value->constvalue)` to `Assert(!value->constisnull)`.
The Const loop that builds the array moved from indxpath.c into make_SAOP_expr() in current code,
so the wrong assertion is re-added there. It wrongly rejects valid Consts whose Datum is 0
(e.g. `x = 0 OR x = 1`) and NULL consts, aborting assert-enabled builds.

Failing oracle case: src/test/regress||create_index
