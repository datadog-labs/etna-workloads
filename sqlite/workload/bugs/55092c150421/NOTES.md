repro.sql: builds a small fts5 table, overwrites its index blocks in x1_data (defensive mode off), then runs a rowid>1 query against it.

Clean shell: both queries report an fts5 corruption error and the shell exits with status 1.
Buggy shell: the process crashes with a segfault (exit status -11).

The upstream test uses simulated OOM, which the shell cannot do. This reproducer reaches the same code path another way, by making the index read fail.
