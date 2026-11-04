Creates an in-memory table (12 rows, columns col_a, col_b, col_c) and runs `SELECT col_c, col_b FROM t LIMIT 5`,
which projects columns in a different order than the schema.
Clean build returns 5 rows. Buggy build returns all 12 rows, because projection pushdown into
MemorySourceConfig rebuilt the source and dropped the `fetch` limit.
