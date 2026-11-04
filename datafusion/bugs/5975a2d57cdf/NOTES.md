Reproducer for null-aware LeftAnti (`NOT IN`) join + dynamic filter pushdown on a nullable build key.
repro.sql writes two small parquet files (build: 5, NULL; probe: 2, 3), enables join dynamic filter pushdown
and parquet pushdown_filters, then runs `SELECT id FROM ao_p WHERE id NOT IN (SELECT eid FROM i_disj_p)`.
Clean returns only 5. Buggy also returns a NULL row, because the pushed filter prunes every probe row
and the join treats the empty probe as an empty subquery.
