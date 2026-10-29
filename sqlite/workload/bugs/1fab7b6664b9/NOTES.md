Reproducer (repro.sh, needs a file DB so a rollback journal exists): auto-vacuum DB with committed t1,t2; in a
transaction modify t2, open savepoints one and two, DROP TABLE t1 (auto-vacuum moves t2's dirty root page),
ROLLBACK TO two. The buggy pager skips sub-journaling the moved page, so t2 loses rows after the rollback:
clean prints `1|2 5|6 3|4` (twice) and `ok`; buggy prints only `1|2` rows.
