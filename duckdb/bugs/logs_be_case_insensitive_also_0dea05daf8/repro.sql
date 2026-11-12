CALL enable_logging(['querylog'], storage='memory');
SELECT value FROM duckdb_settings() WHERE name='enabled_log_types';
