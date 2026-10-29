Reproducer: `IN (SELECT DISTINCT a FROM t3 LIMIT 5)`. The injected patch strips DISTINCT from the subselect, so LIMIT 5 applies to non-distinct rows.
Clean shell prints 3 (distinct values 1,2,3). Buggy shell prints 2.
