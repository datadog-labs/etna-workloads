repro.sql: with foreign_keys=ON, a deferred FK child table cc references pp. In one transaction, drop the parent pp, then the child cc, then COMMIT.
Clean: COMMIT succeeds (exit 0). Buggy: COMMIT fails with "FOREIGN KEY constraint failed" (exit 1), because the missing-parent case no longer decrements the deferred FK counter when cc's rows are deleted during DROP TABLE.
