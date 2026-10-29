Creates a UTF-16 database containing an rtree table, reopens it, and runs a recursive CTE that calls rtreecheck('t3') three times (enc-13.2).
Clean: prints `ok` three times. Buggy: `Error near line 1: database table is locked` (SQLITE_LOCKED from the late encoding detection), and exit=1 from the echo.
