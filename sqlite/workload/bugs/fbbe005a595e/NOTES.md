repro.sql flattens a subquery over an R-Tree virtual table and filters on one of its columns.
The injected bug makes substituted column expressions point at the subquery's pTab instead of the real
(virtual) table. Clean shell prints `1|1.0` and `2|3.0`; the buggy shell aborts with an assertion
failure in sqlite3VdbeExec (p2<pC->nField), exit status -6.
