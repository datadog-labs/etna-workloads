create table t as select g id from generate_series(1,100000) g;
analyze t;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=1; set parallel_leader_participation=on;
explain select * from t;
explain select * from t order by id;
