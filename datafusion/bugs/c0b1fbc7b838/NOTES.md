repro.sql runs a query with a named window used inside a larger expression (`SUM(v1) OVER w + 1`, with `WINDOW w AS (...)`).
The fix makes named-window resolution recurse into nested expressions.
Clean build: returns the 5 rows. Buggy build: the named window is not resolved inside the nested expression, so the query errors (window not defined / planning failure).
