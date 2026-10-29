Reproducer: REPLACE into a table with a CHECK constraint inside a transaction.
The failing REPLACE (a=2) should behave like ABORT: only that statement is rolled back,
the transaction stays open, and the later COMMIT keeps rows 1 and 3.
The buggy shell keeps the REPLACE conflict action for the CHECK failure, which rolls back
the whole transaction, so the output differs (the final SELECT/COMMIT results differ).
