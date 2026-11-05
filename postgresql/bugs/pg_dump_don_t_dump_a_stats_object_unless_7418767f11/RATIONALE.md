# Reintroduced bug: pg_dump dumps extended statistics objects even when their table is not dumped

All changes are in `src/bin/pg_dump/` and reverse `fix_impl.patch`.

- `pg_dump.c`, new function `selectDumpableStatisticsObject()` (fix hunk 1): removed it.
  It cleared `dump` when the stats object's table wasn't being dumped.
- `pg_dump.c`, `getExtendedStatistics()` (fix hunks 2-4): removed the `stxrelid` column from both queries,
  the `i_stxrelid` variable and its `PQfnumber`, and the `stattable = findTableByOid(...)` assignment.
  The call is back to `selectDumpableObject(&statsextinfo[i].dobj, fout)`.
- `pg_dump.h`, `StatsExtInfo` (fix hunk 5): removed the `stattable` field.

Effect: a stats object is selected on schema membership alone. With `-t`, `-T`, `--exclude-table`
or a similar filter, `CREATE STATISTICS` is emitted for tables that are excluded. The dump can then
fail on restore, or contain statements for a table that isn't there.

## Oracle results
The oracle run reports 10039/13808 failing, but that count is not a clean signal of this bug.
In the sandbox, `defaults_tar_format: pg_dump runs` and `pg_restore runs` fail with
"could not generate temporary file name: Read-only file system". That aborts the TAP script at test
3770 of the pg_dump run, so every later case is reported as missing.
Before that point only those two cases were `not ok`. I did not run an unmodified tree, so I can't
say whether the same abort happens there.
Cases that actually exercise the bug are the "should not dump CREATE STATISTICS ..." checks in the
table-filtering runs (for example `exclude_dump_test_schema`, `only_dump_test_table`,
`exclude_test_table`). They did not get to run, so I haven't confirmed that any of them fail because of the bug itself.
