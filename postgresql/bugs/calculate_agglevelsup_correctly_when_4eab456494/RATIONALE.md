# Rationale

File/function: src/backend/parser/parse_agg.c, check_agg_arguments_walker().

Traces to both hunks of fix_impl.patch:
1. Removed the `IsA(node, RangeTblEntry)` block. It treated RTE_CTE references like Vars of the CTE's level. In current code it records min_ctelevel/min_cte, which check_agg_arguments uses to reject or adjust an aggregate that would be evaluated above the CTE. Without it, a CTE reference inside an aggregate's argument does not affect the computed agglevelsup, so the Aggref is placed at the wrong level.
2. Restored `query_tree_walker(..., 0)` in place of `QTW_EXAMINE_RTES_BEFORE`, so RTEs are not visited in subqueries either.

Failing oracle case: src/test/regress||with
