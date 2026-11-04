SET datafusion.execution.max_buffered_batches_per_output_file = 0;
SET datafusion.execution.max_buffered_batches_per_output_file = 1;
SELECT value FROM information_schema.df_settings WHERE name = 'datafusion.execution.max_buffered_batches_per_output_file';
