# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 2ddbfede0c615c009bbbb0f8dfcaa848da5d2376 ("pg_restore: Fix comment handling with --no-policies."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/pg_dump/pg_backup_archiver.c

Failing oracle cases:
- `src/bin/pg_dump|t/002_pg_dump.pl|no_policies_restore: should not dump COMMENT ON POLICY p1`
