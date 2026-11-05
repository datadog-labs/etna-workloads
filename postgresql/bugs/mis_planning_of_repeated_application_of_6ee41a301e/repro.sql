set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0;
set max_parallel_workers_per_gather=4; set parallel_leader_participation=off;
create table t as select i%2+1 as two, i as tenthous from generate_series(1,10000) i;
analyze t;
explain (verbose, costs off)
select generate_series(1, two), array(select generate_series(1, two)) from t order by tenthous;
