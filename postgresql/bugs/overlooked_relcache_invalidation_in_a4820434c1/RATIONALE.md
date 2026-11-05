# Rationale

File: src/backend/commands/tablecmds.c, function ATExecAlterConstraint.
Traces to the fix.patch hunk that added `CacheInvalidateRelcacheByRelid` calls for `otherrelids`, in addition to `CacheInvalidateRelcache(rel)`.
In current code the otherrelids collection lives in ATExecAlterConstrDeferrability, and the invalidation loop is in ATExecAlterConstraint. I removed the `foreach_oid(relid, otherrelids) CacheInvalidateRelcacheByRelid(relid);` loop. As a result, the other relation involved in the FK (holding some of its triggers) no longer gets a relcache invalidation after ALTER CONSTRAINT changes deferrability, so cached trigger data goes stale. This is the original bug.

Failing oracle case: src/test/regress||foreign_key (see oracle output).
