Table t1 has a partial index `WHERE a IS NOT NULL` and 20 rows (some with a NULL).
`SELECT count(*) FROM t1` uses the smallest index for the count. The injection
removes the `pPartIdxWhere==0` check, so the partial index is chosen and the
count omits rows excluded by the index (14 instead of 20).
