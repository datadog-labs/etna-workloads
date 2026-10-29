The reproducer builds a database with a table holding 'abc' in an INTEGER column, then rewrites its schema entry to STRICT through `writable_schema`. It then runs `.clone dst.db`.

The shell's `.clone` runs `sqlite3_step()` on a prepared INSERT. On failure it prints `sqlite3_errmsg()` before it resets the statement. This is the case errmsg-2.3 tests: the error message should be available right after `sqlite3_step()`.

Clean: `Error 3091: cannot store TEXT value in INTEGER column t1.a`

Buggy: `Error 3091: constraint failed`. Only the error code reaches the database handle, not the message.
