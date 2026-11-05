CREATE TABLE num_variance (a numeric);
INSERT INTO num_variance SELECT 9e131071 + x FROM generate_series(1, 5) x;
SELECT variance(a) FROM num_variance;
BEGIN;
ALTER TABLE num_variance SET (parallel_workers = 4);
SET LOCAL parallel_setup_cost = 0;
SET LOCAL max_parallel_workers_per_gather = 4;
SELECT variance(a) FROM num_variance;
ROLLBACK;
