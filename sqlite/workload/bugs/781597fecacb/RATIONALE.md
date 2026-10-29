# Rationale

## Hunk changed: `src/main.c`, `sqlite3_db_readonly()`

Reverses the fix hunk in `src/main.c` that changed the return expression from
`sqlite3PagerIsreadonly(sqlite3BtreePager(pBt))` to `sqlite3BtreeIsReadonly(pBt)`.
The pre-fix expression is restored (`sqlite3PagerIsreadonly` still exists in
`pager.c`). The pager's `readOnly` flag only reflects how the file was opened,
not the BTS_READ_ONLY flag that btree sets when header byte 18 (file-format
write version) is too large. `sqlite3BtreeIsReadonly()` is left in place but unused.

## Oracle failures

`rdonly-1.3.1` fails (expected 1, got 0): after the write version is set to 3,
the database is readable but not writable, yet `sqlite3_db_readonly` reports 0.
Other cases still pass.
