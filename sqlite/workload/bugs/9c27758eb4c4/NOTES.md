Reproducer (`repro.sql`): `SELECT row_number() OVER () FROM t1` (no PARTITION/ORDER BY, no other columns selected).

Clean shell returns 1, 2, 3. The buggy shell lacks the constant placeholder in the window sub-select's expression list, so it hits an assertion failure in sqlite3ExprCodeTarget and aborts (exit -6).
