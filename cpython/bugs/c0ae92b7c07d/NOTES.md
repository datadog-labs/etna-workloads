Creates a dbm.sqlite3 database, makes its directory read-only (r-x), then opens the DB with flag "r" and reads a key.
Clean: prints `b'value'`. Buggy: raises `dbm.sqlite3.error: attempt to write a readonly database`
(the injection drops `immutable=1` / skipping the WAL pragma for read-only opens).
