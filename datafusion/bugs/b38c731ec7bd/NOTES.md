`repro.sql` does a `COPY ... PARTITIONED BY` of an Int8 column and a Float64 column to parquet. It then reads the result back through an external table.

- **df-clean:** the write succeeds (count 1) and the read returns `1 | 2.5 | x`.
- **df-buggy:** the write fails with "not yet supported to write to hive partitions with datatype Int8". The read returns no rows.

The injection removed the Int8/Int16/UInt*/Float* arms in `compute_partition_keys_by_row` (`demux.rs`).
