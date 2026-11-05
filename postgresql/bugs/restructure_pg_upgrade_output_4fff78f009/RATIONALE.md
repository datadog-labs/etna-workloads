# Rationale

Bug: pg_upgrade output dirs were a fixed `pg_upgrade_output.d/{log,dump}` rather than a per-run timestamped dir. `--check` success also did not clean up the output dir.

## Hunks
- `src/bin/pg_upgrade/pg_upgrade.c`, `make_outputdirs()` (fix.patch pg_upgrade.c hunk 2): removed the timestamp, root dir and `rootdir` mkdir. `basedir` (= `rootdir`) is again `$PGDATA/pg_upgrade_output.d`, with `dump` and `log` directly under it. mkdir failures are fatal, so a leftover directory breaks the next run, which is the idempotence problem.
- `src/bin/pg_upgrade/util.c`, `cleanup_output_dirs()` (fix.patch util.c hunk): removed the "remove pg_upgrade_output.d only if empty" logic. Only `basedir` is removed. Because `basedir` is the root again, that cleanup is enough.
- `src/bin/pg_upgrade/check.c`, `report_clusters_compatible()` (fix.patch check.c hunk): removed the `cleanup_output_dirs()` call before `exit(0)` in `--check` mode, so the output dir is left behind after a successful check.

The header and `cleanup()` hunks were not reversed. The timestamped-path comment and macros stay unchanged, since the macros are still valid for the fixed layout.

## Failing oracle cases
- pg_upgrade_output.d/ removed after pg_upgrade --check success
- run of pg_upgrade for new instance
- pg_upgrade_output.d/ removed after pg_upgrade success
- check that locales in new cluster match original cluster
- old and new dumps match after pg_upgrade

The last four fail because the leftover dir from `--check` makes the real run's mkdir fail.
