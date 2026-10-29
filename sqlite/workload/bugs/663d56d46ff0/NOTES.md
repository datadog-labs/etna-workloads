`repro.sql` runs VACUUM inside an open transaction, then issues ROLLBACK.

Clean: VACUUM fails with "cannot VACUUM from within a transaction" and the transaction stays open, so ROLLBACK succeeds.
Buggy: the error path goes through `end_of_vacuum` and ends the transaction. The ROLLBACK then fails with "cannot rollback - no transaction is active".
