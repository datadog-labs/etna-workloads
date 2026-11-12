# Rationale

Hunk: src/planner/binder/statement/bind_alter.cpp, `Binder::Bind(AlterStatement&)`: `!stmt.info->IsAddUniqueConstraint()` -> `!stmt.info->IsAddPrimaryKey()`.
Traces to the fix's last bind_alter.cpp hunk. Only ADD PRIMARY KEY goes through the index-building path again, so ALTER TABLE ADD UNIQUE is a plain catalog alter and creates no unique index.

Oracle results (etna-check):
- test_add_unique.test:14 `INSERT INTO t VALUES (1);` "Query unexpectedly succeeded!" (duplicate not rejected)
- test_add_unique_wal.test:34 internal error "Attempting to get the index of an optional_idx that is not set" (FATAL rollback)
- 2 of 2 oracle units fail
