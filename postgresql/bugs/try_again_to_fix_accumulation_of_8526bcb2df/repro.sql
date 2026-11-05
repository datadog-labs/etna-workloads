create table t1 as select g as hundred from generate_series(1,20000) g;
create table t2 as select g as thousand from generate_series(1,5) g;
analyze t1; analyze t2;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=2; set enable_hashjoin=off; set enable_mergejoin=off; set enable_material=off;
set parallel_leader_participation=off;
alter table t1 set (parallel_workers=2);
alter table t2 set (parallel_workers=0);
select count(*) from t1, t2;
explain (analyze, timing off, summary off, costs off, buffers off)
 select count(*) from t1, t2 where t1.hundred > 1;
