# Rationale

File: src/backend/statistics/extended_stats.c, function lookup_var_attr_stats().
Traces to the fix hunk that replaced the `ereport(ERROR, "extended statistics could not be collected for column ...")` with `pfree(stats); return NULL;` so callers skip (and warn) instead of failing.
Reverted: when a column's per-column stats were not gathered (partial ANALYZE of a column list), lookup now raises an ERROR instead of returning NULL, so ANALYZE of a subset of columns fails whenever an extended statistics object covers other columns.

Failing oracle case: src/test/regress||stats_ext
