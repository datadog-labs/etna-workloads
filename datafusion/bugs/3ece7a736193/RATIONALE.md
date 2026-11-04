# Rationale

Fix #12232 renamed the parquet config option `schema_force_string_view` to
`schema_force_view_types` (config.rs hunk), and updated information_schema.slt
accordingly. In 55.2.0 the option already carries the new name, so the old
name is reintroduced.

Changes (all under `tree/datafusion/*/src`):
- `common/src/config.rs`: the `ParquetOptions` field is named `schema_force_string_view` again
  (reverses the config.rs hunk; the option key `datafusion.execution.parquet.schema_force_string_view`
  is derived from the field name).
- `common/src/file_options/parquet_writer.rs`, `datasource-parquet/src/file_format.rs`,
  `core/src/datasource/{physical_plan,file_format}/parquet*.rs`, `proto-common/src/{from,to}_proto/mod.rs`,
  `proto-models/src/from_proto.rs`: only the Rust field accesses were renamed so it compiles
  (reverses the matching parquet_writer.rs / parquet.rs / proto hunks). Proto message field names are untouched.

Oracle: `information_schema.slt` fails, because `SHOW ALL` / `information_schema.df_settings`
lists `datafusion.execution.parquet.schema_force_string_view` instead of `...schema_force_view_types`.
