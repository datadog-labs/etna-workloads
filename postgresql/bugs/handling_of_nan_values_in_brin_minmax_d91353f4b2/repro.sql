create table t (f4 real, f8 float8);
create index on t using brin (f4 float4_minmax_multi_ops, f8 float8_minmax_multi_ops) with (pages_per_range=128);
insert into t select i, i from generate_series(1,200) i;
insert into t values ('nan','nan');
insert into t select 'nan', 'nan' from generate_series(1,100);
select count(*) from t where f4 = 5;
select count(*) from t where f8 = 'nan';
