# Rationale

## Hunk 1: src/backend/commands/vacuum.c, vacuum()
Traces to the only hunk of fix.patch: the `else { CommandCounterIncrement(); }` branch after
`if (use_own_xacts)` in the ANALYZE loop. I removed it, so with no separate xacts (e.g. inside
BEGIN) consecutive ANALYZE actions are no longer separated by a CCI.

## Hunk 2: src/backend/commands/analyze.c, do_analyze_rel()
Removing hunk 1 alone did not reproduce the bug. Current code has a CCI before
vac_update_relstats() for table relations (added later, for "in case acquirefunc updated pg_class"),
and that CCI happens to separate the pg_statistic updates of consecutive ANALYZEs, which hides the
missing CCI from hunk 1. I removed that CCI, so the second `ANALYZE t` in `ANALYZE t, t` inside a
transaction block no longer sees the first one's pg_statistic changes, and the bug returns.

## Failing oracle cases
- src/test/regress||vacuum
