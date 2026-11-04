repro.sql runs an outer COUNT(*) over ROLLUP / CUBE / GROUPING SETS((v1),(),()) aggregates on an empty input (generate_series ... WHERE false).
The outer count is answered from the inner aggregate's row-count statistics.
Clean: 1, 1, 2 (each empty grouping set emits a grand-total row). Buggy: 0, 0, 0, because the statistics report 0 rows for an empty input.
