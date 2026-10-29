repro.sql creates a table and a VIEW with a named column list (v1(y)), then runs
PRAGMA integrity_check. The injection removes the check that skips non-ordinary
tables (views), so integrity_check tries to verify the view's reused pCheck field.
Clean shell: prints "ok", exit 0. Buggy shell: assertion failure in
sqlite3ExprIfTrue (sqlite3.c:119115), abort (exit -6).
