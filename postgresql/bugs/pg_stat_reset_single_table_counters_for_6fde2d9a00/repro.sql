BEGIN;
COMMENT ON DATABASE postgres IS 'This is a test comment';
SELECT pg_stat_force_next_flush();
COMMIT;
SELECT (n_tup_ins + n_tup_upd) > 0 AS has_data FROM pg_stat_all_tables WHERE relid = 'pg_shdescription'::regclass;
SELECT pg_stat_reset_single_table_counters('pg_shdescription'::regclass);
SELECT (n_tup_ins + n_tup_upd) > 0 AS has_data FROM pg_stat_all_tables WHERE relid = 'pg_shdescription'::regclass;
COMMENT ON DATABASE postgres IS NULL;
