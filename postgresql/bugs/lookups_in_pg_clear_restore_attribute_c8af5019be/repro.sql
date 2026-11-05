CREATE TABLE t(id int);
CREATE INDEX t_i ON t(id);
BEGIN;
SELECT pg_catalog.pg_restore_relation_stats('schemaname','public','relname','t_i','relpages',18::int);
SELECT mode FROM pg_locks WHERE relation='public.t_i'::regclass AND granted ORDER BY mode;
COMMIT;
