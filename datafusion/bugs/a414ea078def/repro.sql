SET datafusion.execution.batch_size = '1';
SET datafusion.execution.target_partitions = '1';
CREATE TABLE filter_limit (i INT) AS VALUES (1), (2);
SELECT COUNT(*) FROM (SELECT i FROM filter_limit WHERE i <> 0 LIMIT 1);
