# Rationale

Both hunks are in src/backend/utils/adt/ruleutils.c, function get_name_for_var_field(). They trace to the two ruleutils.c hunks of fix.patch.

1. SUBQUERY RTE case: the "fN" fallback for a childless Result node (subquery proven empty) is replaced by the original `elog(ERROR, "failed to find plan for subquery %s")`.
2. CTE RTE case: same change, restoring `elog(ERROR, "failed to find plan for CTE %s")`.

With these, EXPLAIN VERBOSE of a whole-row/field reference to an empty-optimized subquery or CTE errors again.

Failing oracle case: src/test/regress||rowtypes
