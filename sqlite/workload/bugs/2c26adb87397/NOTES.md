Reproducer (repro.sql): a FULL JOIN where one term is a VALUES coroutine (viaCoroutine) and the WHERE clause reads its column (`column1 IS NULL`) (test values-19.9).

Clean shell: prints `N|N|N|N|3|4`, exit 0.
Buggy shell: aborts with `Assertion 'pC!=0' failed` in sqlite3VdbeExec (exit -6). The RIGHT JOIN pass is missing the always-NULL OP_OpenPseudo cursor, so OP_Column hits an unopened cursor.
