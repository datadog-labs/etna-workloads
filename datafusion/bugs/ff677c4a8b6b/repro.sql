SET datafusion.explain.analyze_level = dev;
SET datafusion.explain.analyze_categories = 'bytes';
SET datafusion.execution.target_partitions = 4;
SET datafusion.optimizer.hash_join_inlist_pushdown_max_size = 0;
SET datafusion.optimizer.hash_join_inlist_pushdown_max_distinct_values = 0;
EXPLAIN ANALYZE
WITH t1 (k) AS (VALUES (1), (2), (3)), t2 (k) AS (VALUES (1), (2), (3))
SELECT * FROM t1 JOIN t2 ON t1.k = t2.k;
EXPLAIN ANALYZE
WITH t1 (k) AS (VALUES (1), (2)), t2 (k) AS (VALUES (10), (20))
SELECT * FROM t1 CROSS JOIN t2;
