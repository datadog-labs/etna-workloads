SELECT count(*) FROM read_parquet('data/parquet-testing/hive-partitioning/different_order/*/*/*.parquet', hive_partitioning=true, filename='part');
