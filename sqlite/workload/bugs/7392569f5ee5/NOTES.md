repro.sql runs the window4-4.1 query: an aggregate (`max(c)`) combined with a window function over `GROUP BY b`.

- clean: returns `3|1`, `4|2`, `5|3`.
- buggy: fails with "misuse of aggregate: max()". The injection removes `TK_AGG_FUNCTION` from the window rewrite callback, so the aggregate is not carried into the sub-query.
