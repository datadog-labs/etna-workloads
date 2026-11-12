.mode list
.nullvalue NULL
SET debug_verify_column_bindings=true;
CREATE TABLE de_dim AS SELECT i AS k, (i % 7) AS g FROM range(50) _(i);
CREATE TABLE de_a AS SELECT (i % 50) AS k FROM range(5000) _(i);
CREATE TABLE de_b AS SELECT (i % 50) AS k, ((i * 13) % 100)::BIGINT AS metric FROM range(5000) _(i);
SET disabled_optimizers='partial_aggregate_pushdown';
SELECT g, count(b.metric), min(b.metric)
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k)
GROUP BY g
ORDER BY g;
RESET disabled_optimizers;
EXPLAIN SELECT count(b.metric) FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k);
