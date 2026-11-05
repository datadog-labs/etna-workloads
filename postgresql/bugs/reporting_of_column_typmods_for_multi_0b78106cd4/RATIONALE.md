# Rationale

One hunk: `src/backend/parser/analyze.c`, `transformValuesClause()`.

Traces to the fix.patch hunks in `transformValuesClause`. The fix computes a common typmod across all rows of each VALUES column. Before the fix, the typmod came only from the first row (`exprTypmod` of the first row's expression). The current code calls `select_common_typmod(pstate, colexprs[i], coltype)`. I replaced that with `exprTypmod((Node *) linitial(colexprs[i]))`.

The fix also stored coltypes/coltypmods in the RTE and removed the old `expandRTE` and `get_rte_attribute_type` code that derived the info from the first row. Today's code already stores the lists, so I did not reverse those parts. Changing the point where the typmod is computed brings back the same symptom.

Effect: when rows have differing typmods, e.g. `VALUES ('a'::varchar(3)), ('abcdef'::varchar(6))`, the column reports the first row's typmod instead of -1. Views and other consumers then show the wrong column typmod.

Failing oracle case: `src/test/regress||create_view`.
