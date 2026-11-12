.mode list
.nullvalue NULL
SET late_materialization_max_rows = 100;
CREATE TABLE nested_extract AS SELECT
    {'id': k + 1000, 'ms': {'a': k + 200, 'b': k + 30, 'c': {'d': k + 7}}} AS v
FROM range(3) t(k);
SELECT (v.ms::STRUCT(b VARCHAR, a VARCHAR)).b, (v.ms::STRUCT(b VARCHAR, a VARCHAR)).a
FROM nested_extract ORDER BY v.id LIMIT 1;
