repro.sh creates a db with t2's sqlite_master rootpage set to NULL (defensive off, writable_schema), then reopens it and runs `SELECT * FROM t2`.
Clean: "malformed database schema (t2) (11)" (SQLITE_CORRUPT). Buggy: "(4)" (SQLITE_ABORT) because the injected `return 1` makes the init callback abort instead of reporting corruption.
