# Rationale

Fix hunk reversed: `searchWith()` in src/select.c, the `if( p->bView ) break;` line
(fix hunk "@@ -5011,6 +5011,7 @@ static struct Cte *searchWith"). I deleted it, so name
resolution inside a view body again walks out through `pOuter` into CTEs of the
statement that uses the view.

The other fix hunks (`bView` field in With, and selectExpander marking the view's
With) still exist in 3.54.1 but are harmless alone: bView is only consumed by the
removed break, so no further change was needed.

Oracle failure: view2-1.3 (`CREATE VIEW v2 AS SELECT * FROM t1; WITH t1(a,b) AS (SELECT 3,4) SELECT * FROM v2;`)
returns `3 4` instead of `1 2`, since the view's `t1` resolves to the caller's CTE.
view2-1.0 to 1.2 still pass (1.2 passes because the qualified `main.t1` is not matched against CTEs).
