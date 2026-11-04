repro.sql writes a 3-row Parquet file, registers it as an external table, and runs
`SELECT s.x = s.y FROM (SELECT r AS x, r AS y FROM (SELECT random() AS r FROM t) t) s`.
Clean build: every row is `true` (random() is evaluated once and reused).
Buggy build: every row is `false`, because projection pushdown into the file scan
inlines random() at each reference, so x and y are evaluated independently.
