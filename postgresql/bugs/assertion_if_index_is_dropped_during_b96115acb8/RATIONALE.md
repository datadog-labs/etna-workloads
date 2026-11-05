# Rationale

## src/backend/commands/matview.c, refresh_by_match_merge()
Traces to the single hunk of fix_impl.patch (matview.c, same function).
The fix replaced `Assert(foundUniqueIndex)` with a runtime `elog(ERROR)`. In current code
that error is an `ereport(ERROR, ...)`. I reverted it to `Assert(foundUniqueIndex)` and restored
the old comment. If a function called during REFRESH MATERIALIZED VIEW CONCURRENTLY drops the
unique index, no usable index is found. In assert-enabled builds this now aborts the backend
with an assertion failure instead of raising a clean error.

## Failing oracle cases
- src/test/regress||matview (confirmed FAIL in the oracle run; 1/1 cases failing)
