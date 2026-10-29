Reproducer (repro.sql): with foreign_keys=1 and PRAGMA defer_foreign_keys=1 inside a transaction, DROP TABLE of a parent table that still has referencing child rows.
Clean shell: DROP TABLE succeeds (violation is deferred), exit 0.
Buggy shell: "Error near line 8: FOREIGN KEY constraint failed", exit 1 (fkey6-2.3 fails the same way).
