# Rationale

Changed file: src/bin/pg_dump/pg_dump.c, two hunks (the same edit in each).

1. `dumpComment()`, the large-object branch. It traces to the fix.patch hunk `if (dopt->schemaOnly && !dopt->binary_upgrade)`.
   In current code that line is `if (!dopt->dumpData && !dopt->binary_upgrade)`. I changed it back to `if (!dopt->dumpData)`.
2. `dumpSecLabel()`, the large-object branch. It traces to the matching security-label hunk and gets the same change.

In binary-upgrade mode the dump no longer emits comments or security labels on large objects. pg_dump runs with schema-only data, so `dumpData` is false and both functions return early. After pg_upgrade, large object COMMENTs and SECURITY LABELs are lost.

I left the other fix hunks in place (`getLOs` with `|| binary_upgrade`, `_tocEntryRequired`, `ropt->binary_upgrade`). The bug is only that the comment and label dumping is skipped.

Failing oracle cases: the binary_upgrade cases in src/bin/pg_dump/t/002_pg_dump.pl and the test_schema_plus_large_objects cases. The oracle reported 10040 of 13809 cases failing; I did not check why that many fail.
Examples: "binary_upgrade: should dump COMMENT ON LARGE OBJECT ..." and "binary_upgrade: should dump LARGE OBJECT security label".
