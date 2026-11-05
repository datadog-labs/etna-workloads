# Rationale

Hunk: src/backend/replication/logical/tablesync.c, copy_table(). Traces to the single hunk in fix_impl.patch.
The fix made the initial-sync COPY command omit the column list when the table has no columns. This change reverts that: it always emits `COPY tbl (` + columns + `) TO STDOUT`. For a table with no columns that gives `COPY tbl () TO STDOUT`, which is a syntax error, so the initial sync fails.

Failing oracle cases: see the oracle run output (src/test/subscription t/001_rep_changes.pl, notably "check replicated changes for table having no columns" and the cases after it).

Result: all 38 oracle cases in src/test/subscription t/001_rep_changes.pl FAIL (the test aborts during the initial sync of the no-column table, so every case is reported "missing"), including the 8 listed in the task.
