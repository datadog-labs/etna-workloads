create table t1 as select i % 20 as twenty, i as x from generate_series(1,20000) i;
analyze t1;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=4; set enable_hashagg=off;
alter table t1 set (parallel_workers=4);
explain (costs off) select count(*), generate_series(1,2) from t1 group by twenty;
select count(*), generate_series(1,2) from t1 group by twenty order by 1,2 limit 3;
