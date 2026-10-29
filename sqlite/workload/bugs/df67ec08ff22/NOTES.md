repro.sql runs the with2-13.1 query: CTE t3 is a UNION ALL over t2 whose first arm has
`WHERE false`, and t3 is joined with t1 in the outer query.
Clean shell prints `111|222`. Buggy shell prints no rows (both exit 0). The injection
re-enables the push-down optimization for CTEs used more than once (t2 is used twice),
so the `false` term wrongly affects the shared t2 and the second arm returns nothing.
