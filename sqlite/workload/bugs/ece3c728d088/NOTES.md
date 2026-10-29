repro.sh creates a UTF-16 database, then runs `PRAGMA encoding=UTF8` (which should be ignored once the encoding is set) and creates another table. It then reopens the file and selects from sqlite_master (enc2-10.1).
Clean shell: prints `t1` and `t2`, exit 0.
Buggy shell: `malformed database schema (㉴) (11)`, exit 1. The encoding-fixed flag is never set, so the second table was written in UTF-8 into a UTF-16 database.
