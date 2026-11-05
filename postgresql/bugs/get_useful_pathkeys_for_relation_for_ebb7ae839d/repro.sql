create function vf() returns int language plpgsql volatile cost 1 parallel safe as $$ begin return 1; end $$;
create table t1 as select g unique1, g::text::name stringu1 from generate_series(1,10000) g;
create index on t1(unique1);
analyze t1;
set enable_hashagg=off;
set enable_seqscan=off;
set enable_incremental_sort = off;
set parallel_tuple_cost=0;
set parallel_setup_cost=0;
set min_parallel_table_scan_size = 0;
set min_parallel_index_scan_size = 0;
explain (costs off) select distinct sub.unique1, stringu1 || vf()::text
from t1, lateral (select t1.unique1 from generate_series(1, 1000)) as sub;
