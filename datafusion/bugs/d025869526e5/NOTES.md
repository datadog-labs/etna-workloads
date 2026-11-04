Reproducer for the HashJoin multi-column dictionary-key bug (issue #20696).
repro.sql writes two parquet files with Dictionary(Int32, Utf8) state/city columns, enables parquet
pushdown_filters, and runs a 3-key INNER JOIN (time, state, city) with a time-range filter.
df-clean returns the two expected rows. df-buggy fails with "Parquet error ... Can't compare
arrays of different types", because the join's InList dynamic filter flattens the dictionary keys.
