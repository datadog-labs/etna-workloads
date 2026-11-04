SET datafusion.execution.target_partitions = 2;
SET datafusion.execution.batch_size = 200;
CREATE VIEW probe AS SELECT value AS k, 500 AS x FROM generate_series(1, 3);
CREATE VIEW bitwise_wide AS SELECT 2 AS k, value AS v FROM generate_series(1, 20000);
SET datafusion.optimizer.prefer_hash_join = false;
SET datafusion.runtime.memory_limit = '64K';
SET datafusion.execution.sort_spill_reservation_bytes = 0;
SELECT pr.k FROM probe pr WHERE EXISTS (SELECT 1 FROM bitwise_wide wi WHERE pr.k = wi.k AND wi.v <= pr.x - 300);
