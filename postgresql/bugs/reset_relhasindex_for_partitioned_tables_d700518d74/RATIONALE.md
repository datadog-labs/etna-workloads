# Rationale

File: src/backend/commands/analyze.c, function do_analyze_rel(), partitioned-table branch at the end.
Traces to the fix.patch hunk that changed `vac_update_relstats(onerel, -1, totalrows, 0, false, ...)` to pass `hasindex`.
The current code has a different vac_update_relstats signature, but the same call exists. I changed the `hasindex` argument back to `false`.
ANALYZE on a partitioned table then writes relhasindex = false to pg_class, even when the table has indexes. That is the original bug.
The hasindex computation earlier in the function is left alone, since it is harmless without the use.

Failing oracle case: src/test/regress||vacuum
