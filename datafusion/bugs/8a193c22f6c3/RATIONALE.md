# Rationale

Fix hunks reversed: `fetch_schema_with_location` / `fetch_schema` gained a `coerce_int96` argument, and `ParquetFormat::infer_schema` parsed `coerce_int96` and passed it down.

In 55.2.0 that plumbing lives in `datafusion/datasource-parquet/src/file_format.rs`, in `ParquetFormat::infer_schema`. It builds `DFParquetMetadata` and calls `.with_coerce_int96(..)` and `.with_coerce_int96_tz(..)`, and `DFParquetMetadata::fetch_schema` applies the coercion.

Change: `infer_schema` no longer parses `coerce_int96` / `coerce_int96_tz` and no longer passes them to `DFParquetMetadata`. Schema inference therefore ignores the setting, as it did before the fix. The `tz` call is dropped too, since it has no effect without `coerce_int96`. `metadata.rs` is unchanged.

Oracle (`parquet.slt`) failures:
- `describe int96_from_spark` with `coerce_int96 = ms` returns `Timestamp(ns)` instead of `Timestamp(ms)`.
- The same describe with the tz variant fails the same way.
- The following `select *` fails with a Timestamp(ms) to Timestamp(ns) overflow, because the schema says ns while the data is read as ms.
