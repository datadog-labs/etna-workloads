# Rationale

File: src/backend/utils/adt/selfuncs.c, function all_rows_selectable() (the refactored
common helper that now backs examine_variable()/examine_simple_variable() acl_ok checks).

Traces to both fix_impl.patch hunks (examine_variable and examine_simple_variable, which
added `rte->securityQuals == NIL`). In current code that check lives in one place:
`if (rte->securityQuals != NIL) return false;`. I removed it, so statistics are considered
accessible for tables with RLS policies / security barrier quals, letting non-leakproof
selectivity functions see pg_statistic data (the leak).

Failing oracle case: src/test/regress||rowsecurity
