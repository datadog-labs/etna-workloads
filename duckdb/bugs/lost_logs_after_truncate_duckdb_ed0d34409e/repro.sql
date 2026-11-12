.bail off
SET GLOBAL logging_storage = 'memory';
SET GLOBAL logging_level = 'INFO';
SET GLOBAL enable_logging = true;
LOAD invalid_extension;
SELECT COUNT(*) FROM duckdb_logs WHERE starts_with(message, 'Failed to load');
CALL truncate_duckdb_logs();
LOAD invalid_extension;
SELECT COUNT(*) FROM duckdb_logs WHERE starts_with(message, 'Failed to load');
