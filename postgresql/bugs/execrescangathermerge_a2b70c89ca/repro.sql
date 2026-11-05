create table t as select i as u, (i%4)::text as s from generate_series(1,20000) i;
analyze t;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=4; set enable_material=false;
set enable_hashagg=false;
explain (costs off)
select * from (select s, count(u) from t group by s order by s) ss
  right join (values (1),(2),(3)) v(x) on true;
select * from (select s, count(u) from t group by s order by s) ss
  right join (values (1),(2),(3)) v(x) on true;
