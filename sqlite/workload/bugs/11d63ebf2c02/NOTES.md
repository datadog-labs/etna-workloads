`repro.sql` runs join8-6020: `json_each('17') NATURAL RIGHT JOIN t1` with a `(a,b) IN (SELECT rowid, b FROM t1)` term in the WHERE clause.

- Clean shell: prints `17|1|2`.
- Buggy shell: prints `|1|2`. The `value` column is NULL.

The injected bug lets WHERE-clause terms (`EP_InnerJoin`) be used as index constraints on the right side of a RIGHT JOIN. Only ON-clause terms are allowed there.
