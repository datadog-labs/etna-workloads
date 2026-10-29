repro.sh: creates an fts5 table, opens a transaction and does an INSERT, then sends
SIGINT to the shell (via `.output |kill -INT $PPID`), which calls sqlite3_interrupt(),
and then runs ROLLBACK. Each SQL/dot command is a separate command-line argument,
because in non-interactive stdin mode the shell exits on SIGINT.

Clean: ROLLBACK succeeds, `SELECT 'done'` prints done, exit 0.
Buggy: fts5 leaves a blob handle open after the INSERT, so the interrupt flag is not
cleared and ROLLBACK fails with "interrupted (9)"; exit status 1.
