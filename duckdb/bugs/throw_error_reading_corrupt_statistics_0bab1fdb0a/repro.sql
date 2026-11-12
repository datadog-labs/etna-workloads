.shell sh -c "'./build/relassert/duckdb -no-agent -c \"SELECT a FROM \\\"data/parquet-testing/corrupt_stats.parquet\\\" GROUP BY a\" 2>&1 | grep -c Assertion'"
