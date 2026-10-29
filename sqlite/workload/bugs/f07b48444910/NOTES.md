Reproducer (`repro.sql`): rowid table `t3(x INTEGER PRIMARY KEY)` with -1, 0, 1, then `WHERE x<NULL` and `WHERE x<=NULL`.

Clean shell: both queries return no rows. Buggy shell: both return all three rows. The injection drops SQLITE_JUMPIFNULL from the comparison in the rowid-range scan, so a NULL bound no longer ends the loop. This corresponds to where5-3.6 and where5-3.7.
