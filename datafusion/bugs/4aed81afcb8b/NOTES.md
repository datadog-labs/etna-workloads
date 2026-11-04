# Reproducer notes

repro.sql copies the statements from the fix's group_by.slt regression test. It runs a GROUPING SETS query with a duplicated set, `((deptno, job), (deptno, sal), (deptno, job))`, with and without `grouping()` calls.

- df-clean returns 6 rows, with the duplicated `(deptno, job)` set appearing twice per input row. This matches PostgreSQL.
- df-buggy returns 4 rows. The injection drops the duplicate-ordinal bits from `__grouping_id`, so the repeated grouping sets share one key and get merged.

Exit status is 0 on both builds. Only the output differs.
