repro.sql: LEFT JOIN whose right table has a partial index `WHERE NULL IN (c1)`, queried with the same WHERE term.
Clean returns no rows. Buggy wrongly drops the WHERE term for the LEFT JOIN's right table, so it returns the row `0|`.
