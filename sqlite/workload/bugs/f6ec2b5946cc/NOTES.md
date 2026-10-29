repro.sh uses the unix-dotfile VFS to build a DB with an uncommitted, cache-spilled transaction. It copies the db and hot journal while the writer is still open, then opens the copy with unix-dotfile.

Clean: the dotfile `xCheckReservedLock` returns 0 when the connection already holds a lock, so the hot journal is detected and rolled back. `integrity_check` prints `ok` and `sum(z)` is 500500.

Buggy: it always checks for the lock file, which the connection itself just created. The journal is wrongly treated as not hot and not rolled back. `integrity_check` reports a malformed database, exit status 1.
