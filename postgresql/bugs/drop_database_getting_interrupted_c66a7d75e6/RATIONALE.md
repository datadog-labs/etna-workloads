# Re-introducing "Handle DROP DATABASE getting interrupted" (c66a7d75e652)

The fix made `dropdb()` mark the database invalid (`datconnlimit = -2`) with an
in-place, WAL-flushed update before doing irreversible steps. It also made the
backend and client tools refuse or skip invalid databases. The edits below put
back the pre-fix behaviour in REL_18_6. I left the helper functions
`database_is_invalid_form/oid()` and the `DATCONNLIMIT_*` macros in place, now
unused, so the headers and later code still compile. All other uses of the
invalid marker that the fix added are gone.

## Hunks

1. **src/backend/commands/dbcommands.c, `dropdb()`**
   - Traces to the fix hunks at `@@ -1576`, `@@ -1691`, `@@ -1718` and `@@ -1730`.
   - Removed the `systable_inplace_update_begin/finish` block that sets
     `datconnlimit = DATCONNLIMIT_INVALID_DB`, the `XLogFlush()` and the
     delayed `CatalogTupleDelete()`. Also removed the now-unused locals.
   - Restored the old order: the pg_database row is deleted through the
     syscache right after the "being accessed by other users" check, and
     `pgstat_drop_database()` comes after `DropDatabaseBuffers()`.
   - Why this brings the bug back: if DROP DATABASE is interrupted or crashes
     after buffers or files are thrown away, the row deletion rolls back. The
     row then looks completely valid, and the corrupted database stays
     connectable.

2. **src/backend/commands/dbcommands.c, `createdb()`**
   - Traces to the fix hunk at `@@ -977`.
   - Removed the "cannot use invalid database as template" check, so a
     partially dropped database can be used as a template again.

3. **src/backend/commands/dbcommands.c, `AlterDatabase()`**
   - Traces to the fix hunk at `@@ -2346`.
   - Removed the "cannot alter invalid database" check.

4. **src/backend/utils/init/postinit.c, `InitPostgres()`**
   - Traces to the postinit.c fix hunk.
   - Removed the FATAL "cannot connect to invalid database" check, so
     connections to an invalid database are accepted again.

5. **src/backend/commands/vacuum.c, `vac_truncate_clog()`**
   - Traces to the vacuum.c fix hunk.
   - Invalid databases are no longer skipped when computing the frozen
     horizon.

6. **src/backend/postmaster/autovacuum.c, `get_database_list()`**
   - Traces to the autovacuum.c fix hunk.
   - Invalid databases are no longer skipped.

7. **Client tools: invalid databases are listed again.** In each query below I
   dropped the `datconnlimit != -2` / `<> -2` filter:
   - src/bin/pg_amcheck/pg_amcheck.c, `compile_database_list()`
   - src/bin/pg_dump/pg_dumpall.c, `dropDBs()` and `dumpDatabases()`
   - src/bin/scripts/clusterdb.c, `cluster_all_databases()`
   - src/bin/scripts/reindexdb.c, `reindex_all_databases()`
   - src/bin/scripts/vacuumdb.c, `vacuum_all_databases()`

   Each traces to the corresponding client-side fix hunk.

   (`pg_createsubscriber.c` has a similar filter, but it was added later and
   is not part of this fix, so I left it alone.)

## Failing oracle cases
Oracle run: 10055 of 13985 cases FAIL (all others pass).

Breakdown by test file:
- 2 src/bin/pg_amcheck|t/002_nonesuch.pl
- 10041 src/bin/pg_dump|t/002_pg_dump.pl
- 3 src/bin/scripts|t/011_clusterdb_all.pl
- 2 src/bin/scripts|t/091_reindexdb_all.pl
- 2 src/bin/scripts|t/101_vacuumdb_all.pl
- 5 src/test/recovery|t/037_invalid_database.pl

pg_dump 002_pg_dump.pl: 'connecting to an invalid database' fails, because the connection is now accepted. Almost all of the 10041 failures in that file come after that point and cascade from it (for example, all of the defaults_tar_format checks).

Non-pg_dump failing cases:
- src/bin/pg_amcheck|t/002_nonesuch.pl|checking handling of invalid database stderr /(?^:pg_amcheck: error: no connectable databases to check matching "regression_invalid")/
- src/bin/pg_amcheck|t/002_nonesuch.pl|checking handling of object in invalid database stderr /(?^:pg_amcheck: error: no connectable databases to check matching "regression_invalid.public.foo")/
- src/bin/scripts|t/011_clusterdb_all.pl|clusterdb --all --table test1 exit code 0
- src/bin/scripts|t/011_clusterdb_all.pl|clusterdb cannot target invalid database: exit code not 0
- src/bin/scripts|t/011_clusterdb_all.pl|clusterdb cannot target invalid database: matches
- src/bin/scripts|t/091_reindexdb_all.pl|reindexdb cannot target invalid database: exit code not 0
- src/bin/scripts|t/091_reindexdb_all.pl|reindexdb cannot target invalid database: matches
- src/bin/scripts|t/101_vacuumdb_all.pl|vacuumdb cannot target invalid database: exit code not 0
- src/bin/scripts|t/101_vacuumdb_all.pl|vacuumdb cannot target invalid database: matches
- src/test/recovery|t/037_invalid_database.pl|can't ALTER invalid database
- src/test/recovery|t/037_invalid_database.pl|can't connect to invalid database - error code
- src/test/recovery|t/037_invalid_database.pl|can't connect to invalid database - error message
- src/test/recovery|t/037_invalid_database.pl|can't use invalid database as template
- src/test/recovery|t/037_invalid_database.pl|invalid databases are ignored by vac_truncate_clog

Failing pg_dump cases (first 5):
- src/bin/pg_dump|t/002_pg_dump.pl|connecting to an invalid database: exit code not 0
- src/bin/pg_dump|t/002_pg_dump.pl|connecting to an invalid database: matches
- src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: pg_dump runs
- src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: pg_restore runs
- src/bin/pg_dump|t/002_pg_dump.pl|defaults_tar_format: should dump ALTER COLLATION test0 OWNER TO


<!-- produced on retry with opus -->
