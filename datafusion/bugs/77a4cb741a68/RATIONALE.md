# Rationale

File: `datafusion/datasource/src/write/demux.rs`, `row_count_demuxer`.

- Fix hunk reversed: the added `if single_file_output { ... open_file_streams.push(create_new_file_stream(...)); row_counts.push(0); part_idx += 1; }` block that always opens one output file up front. Removed.
- Second path (the bug was fixed twice): 55.2.0 also has `is_batch_received`/`schema` tracking and a trailing block that, for single-file output with no batches, sends `RecordBatch::new_empty(schema)` to the first stream. It only works because of the upfront open, and it also covers the empty-input case, so reversing only the first hunk would give an internal error ("Expected a single output file") rather than the original behaviour. I removed it too (the `schema` variable, `is_batch_received` flag and trailing block). This restores the pre-fix behaviour: with an empty input and single-file output, no file is created.

## Oracle
`copy.slt` fails: `COPY (SELECT 1 AS id WHERE FALSE) TO '.../table_no_rows.parquet'` returns 0 but writes no file, so the following `CREATE EXTERNAL TABLE ... LOCATION` fails with "No files found" and the later `SELECT count(id)` fails with table not found.
