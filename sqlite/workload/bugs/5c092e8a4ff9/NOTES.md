Reproducer (repro.sql): a child table has a composite FK onto a parent's (INTEGER PRIMARY KEY, b) unique index.
DELETE FROM p and UPDATE p SET a=a+1 should fail with "FOREIGN KEY constraint failed".
Clean shell: both fail with that error, and the row stays (200|300), exit status 1.
Buggy shell: the FK check sees NULL instead of the rowid for the IPK column, so the DELETE
succeeds (table becomes empty) and the UPDATE is silently accepted; exit status 0.
