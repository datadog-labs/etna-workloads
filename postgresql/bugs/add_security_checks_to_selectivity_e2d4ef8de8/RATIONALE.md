# Rationale
All changes are in src/backend/utils/adt/selfuncs.c, reversing the fix.patch selfuncs.c hunks that add
`statistic_proc_security_check()` calls before using pg_statistic data with an operator function:
- `var_eq_const`: hunk adding the check to the `HeapTupleIsValid(statsTuple)` condition; the check is removed (opfuncoid still assigned).
- `mcv_selectivity`, `histogram_selectivity`, `ineq_histogram_selectivity`: hunks adding the check before `get_attstatsslot`; removed.
Effect: non-leakproof operators get applied to MCV/histogram stats even when the user lacks SELECT on the column, leaking data via the planner.

Failing oracle case: src/test/regress||privileges
