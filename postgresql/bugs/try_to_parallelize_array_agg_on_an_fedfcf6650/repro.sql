create table pagg_test as select g as x from generate_series(1,5000) g;
analyze pagg_test;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=2;
explain (costs off) select array_dims(array_agg(s)) from (select * from pagg_test) s;
select array_dims(array_agg(s)) from (select * from pagg_test) s;
