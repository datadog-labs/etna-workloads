SET datafusion.execution.target_partitions = 4;
SET datafusion.optimizer.enable_join_dynamic_filter_pushdown = true;
SET datafusion.execution.parquet.pushdown_filters = true;

CREATE TABLE asa_outer(id INT) AS VALUES (1), (2), (3);
CREATE TABLE asa_inner(eid INT) AS VALUES (2), (NULL);

COPY asa_outer TO 'asa_outer.parquet' STORED AS PARQUET;
COPY asa_inner TO 'asa_inner.parquet' STORED AS PARQUET;

CREATE EXTERNAL TABLE asa_outer_parquet(id INT) STORED AS PARQUET LOCATION 'asa_outer.parquet';
CREATE EXTERNAL TABLE asa_inner_parquet(eid INT) STORED AS PARQUET LOCATION 'asa_inner.parquet';

SELECT id FROM asa_outer_parquet WHERE id NOT IN (SELECT eid FROM asa_inner_parquet) ORDER BY id;
