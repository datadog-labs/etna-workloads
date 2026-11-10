# Re-introduced bug: applyChangeset filter failure leaks the DB-wide "ignore next SQLite error" flag

**Bug.** When an `applyChangeset()` filter callback throws, the failure was recorded in the
database-wide `ignore_next_sqlite_error_` flag instead of a per-call variable. Returning false
from `xFilter` is not a SQLite error, so nothing cleared the flag. It stayed set and swallowed the
next unrelated SQLite error, so for example `exec('CREATE TABLEEEE')` did not throw. It also made
the next `applyChangeset()` with a filter skip the filter and apply nothing.

**Changes (all in src/node_sqlite.cc).**
1. In `ApplyChangeset`, I removed the per-call `bool filterCallbackFailed`. This reverses the
   fix hunk that added it.
2. I changed the filter lambda capture back to `[env, db, &filterFunc]`. It now checks
   `db->ignore_next_sqlite_error_` instead of `filterCallbackFailed`, and calls
   `db->SetIgnoreNextSQLiteError(true)` on both failure paths. This reverses the other two fix
   hunks.
3. In `THROW_ERR_SQLITE_ERROR(Isolate*, Database*)`, I removed the `HasPendingException()` guard
   and went back to an unconditional `return` when the flag is set. This hunk has no counterpart
   in the fix. The guard was added after the fix and hides the defect, because it throws the
   SQLite error anyway when no JS exception is pending. With the guard the fix's new assertion
   passes even with hunks 1–2 reverted, so this removal is needed to bring the bug back.

**Failing tests.** `parallel/test-sqlite-session` reports `not ok 1`. The failing subtest is
`filter handler throws`. It failed on both final runs. With the fix's added assertion applied to a
temporary copy, the `database2.exec('CREATE TABLEEEE')` assertion also fails: it expects
`{ code: 'ERR_SQLITE_ERROR', message: /syntax error/ }`, but nothing is thrown.
I did not capture the exact message text of the in-tree failure. I did not edit the test files.
