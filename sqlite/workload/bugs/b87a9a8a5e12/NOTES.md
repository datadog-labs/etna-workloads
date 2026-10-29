Reproducer (`repro.sql`): a temp trigger on main.t1 inserts into `log`, a table in an attached database (aux). Then `ALTER TABLE t1 RENAME a TO b`.

Clean: the rename succeeds (prints `done`, exit 0).
Buggy: the temp-schema trigger is treated as non-temp, so `log` resolves to main and the rename fails with `error in trigger tr1: no such table: main.log` (exit 1).
