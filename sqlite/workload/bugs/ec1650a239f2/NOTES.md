repro.sql: aux.t1 has an FK to t2, which exists only in main. Then aux.t2 is created and
`PRAGMA foreign_key_check=t1` is run again (the fkey5-12.0/12.1 scenario).
Clean: first check prints t1|5|t2|0, t1|7|t2|0, t1|9|t2|0; second prints t1|9|t2|0.
Buggy: both pragmas fail with "database disk image is malformed" (exit status 1),
because the parent table is opened using the wrong schema's database index.
