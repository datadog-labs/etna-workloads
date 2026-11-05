# Rationale

File: src/bin/pg_dump/pg_backup_archiver.c, function `_tocEntryRequired`. Both hunks trace to the single hunk pair in fix_impl.patch.

1. Selective-restore check (fix hunk 1): re-added `"STATISTICS DATA"` to the `ACL`/`COMMENT`/`SECURITY LABEL` group. Statistics entries are again treated as dependent entries, so selectivity options such as `--schema` and `-t` filter them by parent-object marking instead of by name.
2. `ropt->selTypes` block (fix hunk 2): removed the dedicated `STATISTICS DATA` branch that matched table or index names for statistics entries. The `TABLE`/`TABLE DATA`/... chain is a plain `if` again. `--statistics` and `--statistics-only` with `-t` or `-I` are therefore inconsistent.

The result is that `pg_restore --statistics[-only]` handles statistics entries inconsistently under selective restore.

Oracle: 10039 of 13808 cases fail. They are in src/bin/pg_dump t/002_pg_dump.pl, for example `test_schema_plus_large_objects: should not dump ...` and many others reported as `missing`. The `pg_restore runs` cases are affected too.
