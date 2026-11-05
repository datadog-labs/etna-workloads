# Rationale

## Changed hunk
- File/function: `src/src/backend/commands/tablecmds.c`, `ATExecAlterColumnType` (the dependency-scan switch, `case StatisticExtRelationId`).
- Traces to the fix.patch hunk that adds `case OCLASS_STATISTIC_EXT:` calling `UpdateStatisticsForTypeChange(...)` in `ATExecAlterColumnType`. In the current code that hook has become `RememberStatisticsForRebuilding()`.
- Why it brings the bug back: the case now does nothing. ALTER COLUMN TYPE gives the extended-stats machinery no chance to handle a statistics object that depends on the column. The stats object is neither rebuilt nor otherwise fixed up, so it is left stale or broken after the type change.

I did not re-express the other fix hunks. They add the `UpdateStatisticsForTypeChange` function and prototype, add explicit OCLASS cases, and drop the `default:` case. None of them changes behaviour in the current code.

## Failing oracle cases
- src/test/regress||stats_ext
