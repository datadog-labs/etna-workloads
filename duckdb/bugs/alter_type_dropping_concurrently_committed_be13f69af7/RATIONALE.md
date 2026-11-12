# Rationale

All changes are in `src/src/storage/data_table.cpp`, in the `DataTable(ClientContext&, DataTable &parent, idx_t changed_idx, ...)` ALTER TYPE constructor.

1. Lock: `lock_guard<mutex> parent_lock(parent.append_lock)` is back to `lock_guard<mutex> lock(append_lock)`. This is the fix's first hunk. The constructor locks its own unreachable mutex again, so the parent is not protected from concurrent appends.
2. Visibility: the `rewrite_visibility` / `GetLastCommit()` bound is removed. `AlterType` is again passed the altering transaction (`transaction`), so values are resolved at its older snapshot. The new column does not inherit the old update segments, so a committed update the snapshot can't see is lost.
3. Altered mark: the early `parent.version = ALTERED` and the `try/catch` that restored `previous_version` are removed. The mark is set after `AlterType` and `ChangeType`, as before the fix. A transaction committing during the scan no longer conflicts.

I kept the `constraint_to_verify` re-verification, since it is unrelated to this fix.

## Oracle results (`./bin/etna-check`)
```
FAIL     test/sql/alter/alter_type/alter_type_concurrent_committed_update.test
         SELECT v FROM t;  Mismatch on row 1: expected 7, actual 0
PASS     test/sql/alter/alter_type/alter_type_failed_cast_keeps_table_usable.test
1 of 2 oracle units fail
```
`alter_type_failed_cast_keeps_table_usable.test` still passes. Without the early mark there is nothing to restore after a failed cast, because the mark is only set after the scan succeeds. That test only fails with the intermediate state (early mark without the try/catch restore), which is not a state the pre-fix code had. I did not add it, to keep the change faithful. The etna-check exit code is 0 because at least one unit fails.
