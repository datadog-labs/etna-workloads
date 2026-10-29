repro.sh attaches b.db as `aux`, creates aux.t2, runs `PRAGMA table_info(t2)`, then drops t2 from a second shell process on b.db. It then runs `PRAGMA table_info(t2)` again.

Clean: the second pragma returns no rows, because it checks the schema cookie of the `aux` database, reprepares, and finds no t2.
Buggy: the pragma verifies the cookie of `main` instead (`iDb` rather than the table's own database). It doesn't notice that aux changed, so it returns the stale columns d, e and f.
