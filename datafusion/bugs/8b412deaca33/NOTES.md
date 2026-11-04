`repro.sql` builds a table with 'foo', '' and NULL, then runs `WHERE column2 !~ '.*'` and an EXPLAIN of it.

Clean build: the query returns no rows, and the plan filters on `column2 IS NULL AND NULL`.
Buggy build: the optimizer rewrites `!~ '.*'` to `column2 = ''`, so the empty-string row is wrongly returned.
