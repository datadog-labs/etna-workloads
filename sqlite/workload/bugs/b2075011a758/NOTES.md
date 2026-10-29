Reproducer (repro.sql): builds an fts4 table (order=DESC) with two rows, updates them to NULL so the lowest level has segments with only delete markers, then runs the incremental merge `merge=1,4`.

Clean shell: prints `done`, exit 0.
Buggy shell: sqlite3 loops forever in sqlite3Fts3Incrmerge (no output; killed by timeout, exit 124).
