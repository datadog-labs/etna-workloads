Reproducer: two structurally identical correlated `count(*)` scalar subqueries in one projection (`+ 1` and `+ 2`), over the t1/t2 tables from subquery.slt.

Clean: unmatched outer rows get count 0, so a=1, b=2 (22 and 44 have no matches, and 33 gives a=4, b=5).
Buggy: the ScalarSubqueryToJoin rule keys its maps by `Subquery`, so the equal subqueries collide. Column `a` is NULL for t1_id 22 and 44 instead of 1, because the count-bug compensation is applied to only one of the two expressions.
