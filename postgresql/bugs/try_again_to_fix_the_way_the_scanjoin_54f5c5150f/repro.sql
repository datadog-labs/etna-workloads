create table t as select g a, g::text s from generate_series(1,20000) g;
analyze t;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=2;
explain (costs off) select length(s) from t group by length(s);
