Sets `datafusion.execution.parquet.coerce_int96 = ms`, creates an external table over the
`int96_from_spark.parquet` test file, and runs `DESCRIBE`. The file is read through the
relative path `../testdata/parquet-testing/data/int96_from_spark.parquet`. That path
resolves from the checker's working directory, which is a sibling of `testdata/`, so the
script will not run from an arbitrary empty directory.

Clean: `a` is `Timestamp(ms)`. Buggy: schema inference ignores `coerce_int96`, so `a` is `Timestamp(ns)`.
