Reproducer for the TopK + pushdown_filters row-group re-read bug (#24352).
repro.sql builds a 4-row-group parquet file (2048 rows/RG) where one RG has an empty
post-predicate selection, then runs
`SELECT search_phrase FROM q26 WHERE search_phrase <> '' ORDER BY event_time LIMIT 10`
with pushdown_filters and TopK dynamic filters on, single partition.
df-clean returns p0, p4096..p4104. df-buggy re-reads an already-delivered row group:
it returns duplicates (p4096, p4096, p4097, p4097, ...) and drops the true tail (p4101..p4104).
