repro.sql: a GROUP BY over a subquery with ORDER BY ... LIMIT, then ORDER BY a DESC (orderby1-12.0/12.1).
Clean shell returns 2,1 (and 2 with LIMIT 1). Buggy shell wrongly treats the outer ORDER BY as satisfied by the subquery's ASC order, so it returns 1,2 (and 1 with LIMIT 1).
