CREATE TABLE t(id int);
CREATE INDEX t_i ON t(id);
BEGIN;
SELECT pg_restore_relation_stats('schemaname','public','relname','t_i','relpages',18::integer);
SELECT mode FROM pg_locks WHERE relation='t'::regclass AND granted;
COMMIT;
