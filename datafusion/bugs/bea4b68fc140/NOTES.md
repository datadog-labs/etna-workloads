repro.sql writes a small CSV, creates an external table over it with `WITH ORDER (c1, c2 DESC)`, and runs `SHOW CREATE TABLE`.

Clean build: the definition includes `WITH ORDER (c1, c2 DESC)`.
Buggy build: the `WITH ORDER` clause is missing from the definition.
