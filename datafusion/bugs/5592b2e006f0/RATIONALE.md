# Rationale

Fix hunk reversed: in `ListingTableFactory::create`, the fix computed the file extension
as "" when the table path `is_collection()`, otherwise `get_extension(location)`. The pre-fix
code always used `get_extension(location)`.

In 55.2.0 (`datafusion/core/src/datasource/listing_table_factory.rs`) the single-location
branch had the `is_collection()` match. I removed it so a single location always uses
`get_extension(&cmd.locations[0])`. A directory like `foo.v0/` then yields extension `.v0/`-derived
(`v0`), so files inside are filtered out. The multi-location branch (empty extension) is unchanged.

Oracle: `insert_to_external.slt` fails: the `directory_with_dots_readback` CREATE EXTERNAL TABLE
reports "No files found ... external_versioned_parquet_table.v0/" and the following describe/select
fail because the table doesn't exist.
