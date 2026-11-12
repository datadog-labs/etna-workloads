.mode list
.nullvalue NULL
CREATE TABLE quantities AS SELECT i::INTEGER AS q FROM range(1, 101) t(i);
INSERT INTO quantities VALUES (NULL);
CHECKPOINT;
PRAGMA explain_output = OPTIMIZED_ONLY;
EXPLAIN SELECT count(*) FROM quantities WHERE q BETWEEN 1 AND 20;
