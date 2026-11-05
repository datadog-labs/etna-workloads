BEGIN;
SET LOCAL stats_fetch_consistency = snapshot;
SELECT pg_stat_get_xact_numscans('pg_class'::regclass) IS NOT NULL;
SELECT count(*) >= 0 FROM pg_stat_database;
SET LOCAL stats_fetch_consistency = cache;
SELECT count(*) >= 0 FROM pg_stat_database;
SELECT pg_stat_get_numscans('pg_class'::regclass) IS NOT NULL;
SET LOCAL stats_fetch_consistency = none;
SELECT pg_stat_get_numscans('pg_class'::regclass) IS NOT NULL;
SET LOCAL stats_fetch_consistency = snapshot;
SELECT pg_stat_get_numscans('pg_class'::regclass) IS NOT NULL;
COMMIT;
\echo done
SELECT 1;
