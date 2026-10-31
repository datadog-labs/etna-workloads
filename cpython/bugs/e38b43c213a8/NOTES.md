Reproducer: sets a dict-returning row_factory on a sqlite3 connection, creates a table and calls iterdump().
Clean: prints the dump list `['BEGIN TRANSACTION;', 'CREATE TABLE test(t);', 'COMMIT;']`.
Buggy: iterdump no longer resets the cursor's row_factory, so it fails with an exception on dict rows.
