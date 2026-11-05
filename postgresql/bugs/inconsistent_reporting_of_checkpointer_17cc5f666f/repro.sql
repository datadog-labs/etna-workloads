select count(*) as has_slru from information_schema.columns where table_name='pg_stat_checkpointer' and column_name='slru_written';
