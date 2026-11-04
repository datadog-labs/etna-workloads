SET datafusion.execution.target_partitions = 1;
SET datafusion.optimizer.enable_join_dynamic_filter_pushdown = true;
SET datafusion.execution.parquet.pushdown_filters = true;
COPY (SELECT * FROM (VALUES (5), (NULL)) v(id)) TO 'ao_p.parquet' STORED AS PARQUET;
COPY (SELECT * FROM (VALUES (2), (3)) v(eid)) TO 'i_disj_p.parquet' STORED AS PARQUET;
CREATE EXTERNAL TABLE ao_p (id INT) STORED AS PARQUET LOCATION 'ao_p.parquet';
CREATE EXTERNAL TABLE i_disj_p (eid INT) STORED AS PARQUET LOCATION 'i_disj_p.parquet';
SELECT id FROM ao_p WHERE id NOT IN (SELECT eid FROM i_disj_p) ORDER BY id;
