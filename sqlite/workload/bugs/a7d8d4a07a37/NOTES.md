Generated column `z AS (date())` uses a no-argument date function, which must be rejected as non-deterministic.
Clean shell: `INSERT` fails with "non-deterministic use of date() in a generated column".
Buggy shell: the missing `sqlite3NotPureFunc` check lets the insert succeed silently.
