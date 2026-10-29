Reproducer (repro.sql): the subselect-4.x queries from test/subselect.test (ticket #2295).
`b IN (SELECT b FROM t4 ORDER BY b ...)` with TEXT columns should return a,b,c / a / c.
The buggy shell loses the column affinity when the IN subquery has an ORDER BY, so the results differ from the clean shell.
