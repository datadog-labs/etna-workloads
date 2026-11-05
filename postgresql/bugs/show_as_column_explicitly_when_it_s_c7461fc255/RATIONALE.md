Hunk: src/backend/utils/adt/ruleutils.c, get_target_list(), traces to the fix.patch hunk that changed `attname = "?column?"` to `attname = colNamesVisible ? NULL : "?column?"`.
Restored the unconditional `attname = "?column?"`, so AS "?column?" is never shown even when column names are visible (e.g. views/matviews), so deparsed output can change column names.
Failing oracle case: src/test/regress||matview (expected).
