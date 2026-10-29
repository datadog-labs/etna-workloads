`repro.sql` runs `SELECT count(*) FROM sqlite_master;` on an empty in-memory database (count-0.1).
The empty table's root page makes moveToRoot return SQLITE_EMPTY, and the injected bug stops sqlite3BtreeCount from handling it.
Clean shell prints `0` and exits 0. Buggy shell prints "Error near line 1: unknown error" and exits 1.
