Reproducer (`repro.sql`): t2 has a generated column `extra AS (c + 1)` and a column named `othername`; then `ALTER TABLE t1 RENAME a TO othername` renames a column in a different table.

Clean shell leaves t2's schema unchanged. The buggy shell walks generated-column expressions outside the intended branch, so t2 is rewritten to `extra AS (othername + 1)`, which corrupts the schema.
