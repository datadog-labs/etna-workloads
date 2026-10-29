# Rationale

Fix hunk (src/dbstat.c, statBestIndex) removed `aConstraintUsage[iName].omit = 1`
(and the one for schema), so `name=?` is rechecked by SQLite. In 3.54.1 the
schema omit had already been restored elsewhere in the file, so only the name
omit was missing. I re-added `pIdxInfo->aConstraintUsage[iName].omit = 1;` in
`src/dbstat.c`, which reverses the name part of the fix.

With omit set, SQLite does not re-check `name = NULL`, and the vtab's xFilter
treats a NULL name as no constraint, returning all rows.

Failing oracle case: stat-8.4 (`SELECT * FROM st4 WHERE name = NULL` returns
rows instead of an empty result). stat-8.5 still passes because the schema omit is unchanged.
