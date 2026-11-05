# Rationale

## Changed hunks

1. `src/backend/access/transam/xlog.c`, `do_pg_backup_start()`
   - Traces to the xlog.c hunk of fix.patch. I removed the `else if (de_type == PGFILETYPE_DIR)` branch that handles in-place tablespaces.
   - Directories directly under `pg_tblspc` now fall into the "skip any other file type" branch. Only symlinks are treated as tablespaces. This matches the pre-fix behavior, where anything that isn't a symlink/junction was skipped.
   - An in-place tablespace is therefore left out of the tablespace list and the backup contains no tar for it.

2. `src/bin/pg_basebackup/pg_basebackup.c`, `CreateBackupStreamer()`
   - Traces to the pg_basebackup.c `@@ -1122` hunk.
   - A relative `spclocation` is no longer prefixed with `basedir`. The directory is `get_tablespace_mapping(spclocation)` for every tablespace.

3. `src/bin/pg_basebackup/pg_basebackup.c`, `BaseBackup()`
   - Traces to the pg_basebackup.c `@@ -1955` hunk.
   - The tablespace directory is again created from `get_tablespace_mapping()` of the raw path, with no `basedir` prefix for relative paths.

The `bbstreamer_file.c` hunk (`should_allow_existing_directory`) is not reverted.

## Oracle result

Failing:
- `src/bin/pg_basebackup|t/011_in_place_tablespace.pl|one tablespace tar was created`

Still passing:
- `backup tar was created`
- `pg_basebackup runs`

The test takes a tar-format backup, so only change 1 triggers the failure. Changes 2 and 3 affect plain-format backups, which the oracle doesn't cover.
