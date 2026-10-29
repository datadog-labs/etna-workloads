Reproducer (`repro.sql`): in one transaction, create an fts5 table, rename it, then drop it, and commit.

Clean shell: no errors, exit status 0. Buggy shell: `DROP TABLE t2` fails with "SQL logic error" and the exit status is 1.
This matches fts5misc-18.1. The injected bug brings back the old savepoint-flush code, which fails after a rename.
