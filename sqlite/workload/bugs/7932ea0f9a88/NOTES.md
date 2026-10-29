repro.sql: the joinH-17.2 case. A RIGHT JOIN against t0, where t0 has a unique index on c2 and the WHERE clause compares t0.c2 with a correlated scalar subquery. The RIGHT JOIN subroutine reuses the register that drives the index, so the affinity applied to it leaks into the loop body.
Clean shell: returns two rows (0, 0). Buggy shell: returns only one row (0).
