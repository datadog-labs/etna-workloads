Reproducer (`repro.sql`): create an FTS3 table, then inside a transaction insert a row, rename the table, insert again, and COMMIT (fts3ao-4.1 to 4.6).

- clean: COMMIT succeeds and `SELECT * FROM t5` returns the three rows.
- buggy: COMMIT fails with "SQL logic error", the transaction rolls back, and `t5` doesn't exist.

Cause: the buggy build doesn't flush the pending terms in the rename method, and doesn't reset `p->expired` after OP_VRename.
