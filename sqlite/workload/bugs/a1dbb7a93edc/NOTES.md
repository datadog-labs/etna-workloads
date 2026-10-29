The tests use a Tcl virtual table that consumes ORDER BY and sees DISTINCT in xBestIndex. The shell has no Tcl module, so this uses the built-in `generate_series` instead. It also consumes ORDER BY, on `value`.

`repro.sql` runs `EXPLAIN QUERY PLAN SELECT DISTINCT value FROM generate_series(1,5)`.

- **Clean:** the plan has no temp b-tree, because the vtab's ordering is used to de-duplicate.
- **Buggy:** the plan adds `USE TEMP B-TREE FOR DISTINCT`. This is the extra IdxInsert that bestindexF-1.1.1 and bestindex8-1.2.3/1.3.3 check for.

Query results are the same on both shells. Only the plan differs.
