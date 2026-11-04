set datafusion.execution.parquet.pushdown_filters = true;
set datafusion.execution.target_partitions = 1;
set datafusion.optimizer.enable_dynamic_filter_pushdown = true;
set datafusion.optimizer.enable_topk_dynamic_filter_pushdown = true;

CREATE TABLE q26_src AS
SELECT
  CAST(CASE
    WHEN i < 2048 THEN i * 1000
    WHEN i < 4096 THEN (CASE WHEN i = 2048 THEN 50 ELSE 20000 + i END)
    WHEN i < 6144 THEN 100 + (i - 4096)
    ELSE 5000 + (i - 6144)
  END AS BIGINT) AS event_time,
  CASE WHEN i = 2048 THEN '' ELSE 'p' || CAST(i AS VARCHAR) END AS search_phrase
FROM generate_series(0, 8191) AS t(i);

COPY (SELECT * FROM q26_src) TO 'q26.parquet' STORED AS PARQUET
OPTIONS ('format.max_row_group_size' '2048');

CREATE EXTERNAL TABLE q26 (event_time BIGINT NOT NULL, search_phrase VARCHAR NOT NULL)
STORED AS PARQUET LOCATION 'q26.parquet';

SELECT search_phrase FROM q26 WHERE search_phrase <> '' ORDER BY event_time LIMIT 10;
