.mode list
.nullvalue NULL
CREATE TABLE input AS SELECT i AS id, CASE WHEN i=0 THEN NULL ELSE i END AS nullable_id,
                           CASE WHEN i%10=0 THEN 'special' ELSE 'ordinary' END AS label
FROM range(1000) r(i);
SET disabled_optimizers='statistics_propagation';
PRAGMA explain_output='optimized_only';
EXPLAIN (FORMAT JSON) SELECT * FROM input WHERE id IS NOT NULL;
