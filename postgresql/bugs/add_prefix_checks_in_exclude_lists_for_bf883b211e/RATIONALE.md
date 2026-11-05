# Rationale
The fix added `match_prefix` to exclude lists so `pg_internal.init*` temp files are excluded. I set `match_prefix` back to false for that entry, so it is matched exactly (the old `strcmp` behavior).

- `src/backend/backup/basebackup.c`, `excludeFiles[]`: `{RELCACHE_INIT_FILENAME, true}` -> `false`. This traces to the fix.patch hunk that changed `RELCACHE_INIT_FILENAME` to `{..., true}`. Base backups no longer skip `pg_internal.init.<pid>` temp files.
- `src/bin/pg_checksums/pg_checksums.c`, `skip[]`: `{"pg_internal.init", true}` -> `false`. This traces to the same hunk in the pg_checksums.c part of the patch. pg_checksums no longer skips prefixed files.
- `src/bin/pg_rewind/filemap.c`, `excludeFiles[]`: `{"pg_internal.init", true}` -> `false`. This traces to the matching filemap.c hunk. pg_rewind no longer excludes prefixed files.

Failing oracle cases: 30 of 266, mostly in `src/bin/pg_checksums|t/002_actions.pl`. Examples: "succeeds with offline cluster", "verifies checksums as default action", and the "fails with corrupted data ..." stdout/stderr cases.
