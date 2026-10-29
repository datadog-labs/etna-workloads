repro.sql: creates a trigger whose INSERT ... ON CONFLICT DO UPDATE targets a nonexistent table (logx), then runs ALTER TABLE log RENAME COLUMN a TO x.

Clean shell: prints "error in trigger tr1: no such table: main.logx", exit 1.
Buggy shell: assertion failure `rc==SQLITE_OK` in renameResolveTrigger (abort, exit -6).
