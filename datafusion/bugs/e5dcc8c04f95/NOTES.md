repro.sql creates t(x,y) with a row where x=0 and runs `select coalesce(1, y/x), coalesce(2, y/x) from t`.
Clean build: coalesce is simplified to a lazy CASE, so y/x is never evaluated; returns 1,2 for all rows.
Buggy build: coalesce evaluates all arguments eagerly, so it fails with "Arrow error: Divide by zero error".
