repro.sql: builds a 5-row table and filters the output of `ORDER BY value LIMIT 3` in a subquery.
Clean: filter stays above the Sort (TopK), so results are the single row (3, 300) for both queries.
Buggy: the filter is pushed below the Sort+fetch, so it returns wrong rows (3,4,5 / 3,2,1) and the EXPLAIN plan has FilterExec under SortExec(TopK).
