# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 3db61db48ef5b8898f7e85f98548fdec79d76524 ("Change the names generated for child foreign key constraints."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/pg_constraint.c, src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/isolation||detach-partition-concurrently-2`
- `src/test/isolation||detach-partition-concurrently-4`
- `src/test/isolation||fk-partitioned-1`
- `src/test/isolation||fk-partitioned-2`
- `src/test/regress||constraints`
- `src/test/regress||foreign_key`
- `src/test/regress||without_overlaps`
