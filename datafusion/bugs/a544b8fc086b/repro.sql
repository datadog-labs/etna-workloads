SET datafusion.execution.target_partitions = 4;
SET datafusion.optimizer.enable_dynamic_filter_pushdown = true;
SET datafusion.optimizer.enable_aggregate_dynamic_filter_pushdown = true;
CREATE TABLE agg_source AS SELECT column1 AS category, column2 AS score FROM (VALUES ('alpha', 10), ('alpha', 25), ('beta', 5), ('beta', 12), ('gamma', 42), ('gamma', 8));
COPY agg_source TO 'agg_data.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE agg_parquet(category VARCHAR, score INT) STORED AS PARQUET LOCATION 'agg_data.parquet';
EXPLAIN SELECT COUNT(*), MAX(score) FROM agg_parquet WHERE category = 'alpha';
SELECT COUNT(*), MAX(score) FROM agg_parquet WHERE category = 'alpha';
