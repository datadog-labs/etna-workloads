SELECT backend_type, count(*) FROM pg_stat_io
WHERE backend_type IN ('walreceiver','walsummarizer','walwriter') AND object <> 'wal'
GROUP BY 1 ORDER BY 1;
