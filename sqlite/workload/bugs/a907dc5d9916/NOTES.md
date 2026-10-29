`repro.sql` uses a recursive CTE that calls itself as a table-valued function, `RIGHT JOIN cte1(x)`.

- clean: `'cte1' is not a function`
- buggy: `too many arguments on cte1() - max 0`

Both shells exit with status 1. Only the error message differs, because the buggy build lacks the `IsVirtual` check in `sqlite3WhereTabFuncArgs`.
