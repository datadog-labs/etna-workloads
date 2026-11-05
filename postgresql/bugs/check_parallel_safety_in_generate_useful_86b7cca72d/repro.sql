create table t1 as select g as unique1 from generate_series(1,10000) g;
create unique index t1_u on t1(unique1);
vacuum analyze t1;
set parallel_setup_cost=0; set parallel_tuple_cost=0; set min_parallel_table_scan_size=0; set min_parallel_index_scan_size=0;
set max_parallel_workers_per_gather=2;
explain (costs off) select unique1,
  (select t.unique1 from t1 where t1.unique1 = t.unique1)
from t1 t, generate_series(1, 1000)
order by 1, 2;
