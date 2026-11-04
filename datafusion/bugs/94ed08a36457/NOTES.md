Reproducer: writes a Hive-partitioned Parquet dataset from a Dictionary(Int32, Utf8) column
(`COPY ... PARTITIONED BY (column1)`) with rows foo, bar, foo, then reads it back.

Clean: COPY writes 3 rows and the read-back returns them correctly.
Buggy: the partition-key code iterates the dictionary's values instead of per-row keys, so it
gets 2 values for 3 rows. The write panics (index out of bounds in demux.rs), exit status 101.
