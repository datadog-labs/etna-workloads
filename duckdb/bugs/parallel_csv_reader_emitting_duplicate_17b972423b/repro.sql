SELECT count(*) FROM read_csv('data/csv/one_r_n_two.csv', auto_detect=false, header=false, delim=',', columns={'a':'VARCHAR'}, strict_mode=false, ignore_errors=true, buffer_size=10, parallel=true);
