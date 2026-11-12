select count(*) from read_csv('data/parquet-testing/oob_gzip/half_footer.gz', compression='gzip', header=false, delim='|', quote='', escape='');
