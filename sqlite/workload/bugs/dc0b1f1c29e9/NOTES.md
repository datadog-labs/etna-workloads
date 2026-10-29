Reproducer: in a transaction, insert NULL into the PRIMARY KEY of a WITHOUT ROWID table, then ROLLBACK.
Clean: the implied NOT NULL uses ABORT, so the transaction stays open and ROLLBACK succeeds (only the NOT NULL error is printed).
Buggy: the implied NOT NULL uses ROLLBACK, so the failed insert rolls back the transaction and the explicit ROLLBACK also errors ("cannot rollback - no transaction is active").
