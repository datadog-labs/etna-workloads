repro.sql creates a small table and runs `select a from t group by a order by min(b)` (plus a `min(b) + max(b) desc` variant). The ORDER BY aggregate is not in the select list.
Clean build: returns the ordered rows (1,3,4 and 4,3,1). Buggy build: planning error "Column in ORDER BY must be in GROUP BY or an aggregate function", because the injection stops collecting aggregates from ORDER BY.
