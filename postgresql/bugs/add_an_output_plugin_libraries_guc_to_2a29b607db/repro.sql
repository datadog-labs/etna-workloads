SET output_plugin_libraries = pgoutput;
SELECT 'init' FROM pg_create_logical_replication_slot('regression_slot', 'test_decoding');
