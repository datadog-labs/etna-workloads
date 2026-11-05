create function unsafe_f() returns int language plpgsql parallel restricted as $$ begin return 0; end $$;
create table t1 as select g as unique1 from generate_series(1,10000) g;
create table t2 as select g%10 as ten from generate_series(1,10000) g;
analyze t1; analyze t2;
set parallel_setup_cost=0; set parallel_tuple_cost=0;
set min_parallel_table_scan_size=0; set max_parallel_workers_per_gather=2;
alter table t1 set (parallel_workers=4);
alter table t2 set (parallel_workers=0);
explain (costs off)
 select * from t1 where (unique1 + unsafe_f())::integer not in (select ten from t2);
