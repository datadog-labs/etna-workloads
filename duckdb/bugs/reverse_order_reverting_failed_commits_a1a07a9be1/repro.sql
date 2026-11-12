.bail off
CREATE TABLE indexed_t(a INTEGER PRIMARY KEY, b INTEGER);
INSERT INTO indexed_t VALUES (1, 10), (2, 20), (3, 30);
CREATE INDEX indexed_t_b ON indexed_t(b);
SET debug_force_commit_failure=true;
BEGIN;
UPDATE indexed_t SET b = 99 WHERE a = 2;
COMMIT;
SET debug_force_commit_failure=false;
SELECT a, b FROM indexed_t ORDER BY a;
