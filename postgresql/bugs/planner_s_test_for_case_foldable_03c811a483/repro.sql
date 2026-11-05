create table t(a int, b text collate "und-x-icu");
insert into t values (1,'abc'),(4,'ABC');
create index t_idx on t(b);
set enable_seqscan = off;
explain (costs off) select * from t where b ilike 'abc';
select * from t where b ilike 'abc' order by a;
