# Rationale

File: src/bin/pg_dump/pg_dump.c, function dumpTableSchema.
Traces to the fix.patch hunk `@@ -17686,6 +17704,56 @@ dumpTableSchema`, which added the block
dumping `COMMENT ON CONSTRAINT ... ` for valid not-null constraints (notnull_comment[]).
That block is removed, so comments on valid (inlined) not-null constraints are silently
dropped from pg_dump output. The remaining query/struct plumbing from the fix is left in place
(unused), as it is harmless.

Failing oracle cases: the 002_pg_dump.pl case
"COMMENT ON CONSTRAINT ON test_table_chld2" in the full-run / dump_test_schema / section_pre_data
variants (see o.txt for the list).

Note: in this sandbox the tar-format run aborts 002_pg_dump.pl early ("Read-only file system"),
so many later cases also show as FAIL ('missing'); that is an environment artifact.
