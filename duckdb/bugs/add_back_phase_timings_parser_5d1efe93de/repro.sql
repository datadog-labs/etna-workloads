CALL enable_logging('Metrics', storage='memory');
SET tracked_metrics = ['parser.total_time'];
SET enable_profiling = 'no_output';
SELECT 42;
SELECT 43;
CALL disable_profiling();
SELECT count(*) FROM duckdb_logs_parsed('Metrics') WHERE metric = 'parser.total_time';
