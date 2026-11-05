create table t1 as select g as unique1, g%5000 as fivethous from generate_series(0,9999) g;
create table t2 as select g as unique1, g%5000 as fivethous from generate_series(0,9999) g;
vacuum analyze t1; vacuum analyze t2;
set parallel_setup_cost=0;
set parallel_tuple_cost=0;
set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=4;
explain (costs off)
select * from t1 where exists (select 1 from t2 where fivethous = t1.fivethous) and t1.fivethous < 5;
