# Rationale

## Changed hunks (src/bin/pg_dump/pg_dump.c, function `getFuncs`)

Traces to the `getFuncs` hunks of fix_impl.patch (reversed).

1. 9.6+ query branch: removed the `OR EXISTS (... pg_cast ... castfunc)` and
   `OR EXISTS (... pg_transform ... trffromsql/trftosql)` clauses (and their
   `g_last_builtin_oid` format args) from the pg_catalog exclusion filter.
2. Pre-9.6 query branch: removed the same pg_cast / pg_transform EXISTS clauses.

The comment-only hunk was not reverted. The `exit_horribly` vs `return` hunks in
`dumpCast`/`dumpTransform` were not reverted: current code uses `pg_fatal`.

## Why this brings back the bug
pg_dump no longer collects built-in (pg_catalog) functions used by user-defined
casts/transforms. `dumpCast`/`dumpTransform` then cannot find the function via
`findFuncByOid` and fail with "could not find function definition for function
with OID ...".

## Failing oracle cases
13771 of 13808 fail, mostly in src/bin/pg_dump t/002_pg_dump.pl (all runs
whose dump aborts, e.g. the test_schema_plus_large_objects "should not dump ..."
cases). See logs/oracle.log.
