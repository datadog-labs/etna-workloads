SET datafusion.execution.parquet.schema_force_view_types = false;
SHOW datafusion.execution.parquet.schema_force_view_types;
SELECT name, value FROM information_schema.df_settings WHERE name LIKE '%schema_force%' ORDER BY name;
