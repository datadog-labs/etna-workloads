# Rationale

## Changed hunk
`src/build.c`, `sqlite3SrcListFuncArgs()`: `if( p ){` -> `if( p && pList ){`.
This reverses the fix's build.c hunk (`if( p && pList )` -> `if( p )`).
With empty argument list `t(`)`, the parser passes pList==NULL, so isTabFunc is
never set and the later "'%s' is not a function" checks (cannotBeFunction() in
select.c, still present, and sqlite3WhereTabFuncArgs) are skipped. Tables, views
and CTEs may then be used with function syntax `v1()`. The else branch only
deletes pList (NULL, a no-op), so there is no leak.

The other fix hunks (select.c cannotBeFunction, resolve.c, whereexpr.c) are
still present in 3.54.1 and were left intact; they only guard the isTabFunc case.

## Failing oracle cases
tabfunc01-1.21.2 (`SELECT * FROM v1()`), tabfunc01-1.23.2 (`SELECT * FROM v2()`),
tabfunc01-1.26 (`INSERT ... SELECT * FROM w0()` on a CTE): the expected
"'x' is not a function" error is not raised.
