repro.sql runs the with1-28.1 query: a recursive CTE with UNION / UNION / recursive-select ORDER BY, used as a correlated scalar subquery over t1.
The clean shell prints NULL, 1, NULL. The buggy shell (OPFLAG_USESEEKRESULT wrongly set on the OP_IdxInsert in generateOutputSubroutine for SRT_DistQueue) aborts with an assertion failure in insertCellFast (exit -6).
