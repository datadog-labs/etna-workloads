SELECT count(*) FROM read_csv('data/csv/error/banklist.csv', columns={'a':'INTEGER'}, store_rejects=true, rejects_scan='foo_bar', rejects_table='baz', auto_detect=false, ignore_errors=true, delimiter='|');
SELECT count(*) FROM read_csv('data/csv/error/banklist.csv', columns={'a':'INTEGER'}, store_rejects=true, rejects_scan='foo', rejects_table='bar_baz', auto_detect=false, ignore_errors=true, delimiter='|');
SELECT table_name FROM information_schema.tables WHERE table_name IN ('foo_bar','baz','foo','bar_baz') ORDER BY 1;
