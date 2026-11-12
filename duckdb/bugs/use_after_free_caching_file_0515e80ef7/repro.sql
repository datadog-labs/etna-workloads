SET threads=1;
SET async_threads=1;
SELECT count(*), sum(l_extendedprice) FROM read_parquet(['data/parquet-testing/lineitem-top10000.gzip.parquet' for i in range(40)]) WHERE l_orderkey % 1000 = 1;
