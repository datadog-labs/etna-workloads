Reproducer (repro.sql): creates a two-column FTS5 table with detail=none, inserts three rows
(test fts5simple2-9.1/9.2.1), then runs the 'integrity-check' command.

Clean shell: no output, exit 0. Buggy shell: `fts5: checksum mismatch for table "t1"`, exit 1.
With the bug, detail=none tables use the wrong termset and position/column values when indexing,
so the index checksum computed on insert differs from the one computed by integrity-check.
