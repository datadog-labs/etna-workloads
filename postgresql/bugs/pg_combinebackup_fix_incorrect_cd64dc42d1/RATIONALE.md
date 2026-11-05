# Rationale

File: src/bin/pg_combinebackup/pg_combinebackup.c, function process_directory_recursively()
Traces to the pg_combinebackup.c hunk of fix.patch. The call to reconstruct_from_incremental_file() again passes `relative_path` (the path relative to the tablespace root, no trailing slash, and NULL at the top level) instead of `manifest_prefix` (the path relative to the backup root, with trailing slash, including pg_tblspc/<oid>/). For files in user tablespaces, the prior-backup file lookup then uses the wrong directory, so reconstruction breaks.

Failing oracle cases (src/bin/pg_combinebackup|t/002_compare_backups.pl):
- contents of dumps match for both PITRs
- dump from PITR 1
- dump from PITR 2
