Reproducer for the autoinc-9.1 bug (ticket #3148): an empty INSERT ... SELECT into an AUTOINCREMENT table.

`repro.sql` creates t2 with one row and an empty t3. It runs `INSERT INTO t3 SELECT * FROM t2 WHERE y>1`, which inserts no rows, and then selects t3's row from sqlite_sequence.

The clean shell prints `t3|0`. The buggy shell doesn't initialize the sequence value when the table has no sqlite_sequence entry, so it stores a garbage value or NULL.
