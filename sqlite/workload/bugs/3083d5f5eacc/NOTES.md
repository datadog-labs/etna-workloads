Reproducer (`repro.sql`): table with a NOT NULL column `c` and a trigger using `c NOT NULL`, then `ALTER TABLE t1 RENAME c TO d`.
Clean: rename succeeds and the trigger SQL is rewritten to use `d`.
Buggy: the NOT NULL expression is folded at prepare time during rename, so the rename fails with "error in trigger tr1 after rename: no such column: c" (exit 1).
