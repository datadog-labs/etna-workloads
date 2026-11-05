SELECT pg_stat_reset_single_table_counters('pg_shdescription'::regclass);
SELECT stats_reset AS b FROM pg_stat_database WHERE datid = 0 \gset
SELECT pg_sleep(0.05);
SELECT pg_stat_reset_single_table_counters('pg_shdescription'::regclass);
SELECT stats_reset IS NOT NULL AND stats_reset > :'b'::timestamptz AS has_updated
  FROM pg_stat_database WHERE datid = 0;
