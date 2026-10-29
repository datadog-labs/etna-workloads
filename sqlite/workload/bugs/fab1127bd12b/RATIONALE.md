# Rationale

Fix: `PRAGMA temp_store_directory` must treat an error return from `xAccess()` as "not writable".

Change (`tree/src/pragma.c`, temp_store_directory branch): the return value of `sqlite3OsAccess()` is again ignored and only `res==0` is checked (reverses the `rc!=SQLITE_OK || res==0` hunk). On I/O error `res` is left unset/0-initialised by nothing, so the pragma no longer reliably reports "not a writable directory". The data_directory branch was left untouched, as the fix did not touch it.

Oracle: `ioerr2-6` fails (the injected I/O error on xAccess no longer yields `1 {not a writable directory}`).
