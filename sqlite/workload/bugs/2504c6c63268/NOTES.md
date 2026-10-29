Reproducer: repro.sql runs EXPLAIN QUERY PLAN on `SELECT 5 ORDER BY 1` and on a UNION ALL of constant SELECTs with ORDER BY (orderby1-5.0/5.1).
Clean shell: no sorting step (a FROM-less query returns one row). Buggy shell: the plan adds "USE TEMP B-TREE FOR ORDER BY" to the first query and to each arm of the second.
