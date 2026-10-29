repro.sql: LEFT JOIN t2->t3 where t3 has UNIQUE(x,y); the ON clause uses x and WHERE uses `y IS NULL` (ticket #2177, where4-3.2).
Clean: rows `2|2|` and `3||`. Buggy: an extra wrong row `1||` appears, because the IS NULL term on the right table of the LEFT JOIN is used for index lookup.
