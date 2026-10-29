Reproducer: `repro.sql`. It creates three tables, sets a CLI progress handler (every 5 opcodes, interrupting once at callback 21), then runs `.dump`.

`.dump` runs inner queries (the row-dump SELECT) while its outer sqlite_schema query is still active, like the nested query in progress-1.7. The handler interrupts one inner query.

- Clean: only that inner query is abandoned. The dump still emits `CREATE TABLE b`, its `INSERT`, and `CREATE TABLE c`.
- Buggy: the extra `sqlite3_interrupt()` sets the interrupt flag, which aborts the outer query too. The dump stops after the first table.

Both shells print `ROLLBACK; -- due to errors` and exit with status 1.
