repro.sql runs the rowvalue-17.1 and 18.6 queries: a join with `(a, b) IN (SELECT/VALUES ...)` in WHERE.
Clean shell: returns rows `1|1|1` and `1|2|1` for the second query, with exit status 0.
Buggy shell: both queries fail with "sub-select returns 2 columns - expected 1", exit status 1.
