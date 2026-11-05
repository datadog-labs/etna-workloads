create table t1 as select g as a, g%2 as two, 'AAAA'||g as s from generate_series(1,20000) g;
create table t2 as select g as a, g%2 as two from generate_series(1,20000) g;
analyze t1; analyze t2;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=4;
explain (costs off) select * from t1 a where two in (select two from t1 b where s like '%AAAA1%' limit 3);
