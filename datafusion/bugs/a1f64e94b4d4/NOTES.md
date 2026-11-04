repro.sql sets `datafusion.execution.max_buffered_batches_per_output_file` to 0 and then 1, then reads the value back from `information_schema.df_settings`.

- df-clean rejects both SETs with "value must be at least 2", and the setting stays at 2.
- df-buggy accepts both SETs silently, and the setting reads back as 1.
