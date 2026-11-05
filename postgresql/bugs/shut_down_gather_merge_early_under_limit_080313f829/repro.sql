create table t as select g as u from generate_series(1,10000) g;
alter table t set (parallel_workers = 1);
create table s as select g as u from generate_series(0,1) g;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set enable_material=off; set enable_hashjoin=off; set enable_mergejoin=off;
set max_parallel_workers_per_gather=1;
select count(*) from s left join (select u from t order by 1 limit 1000) ss on s.u < ss.u + 1;
