create table t(f float8) with (autovacuum_enabled=off);
insert into t select i/10.0 from generate_series(1,2000) i;
create index on t using brin(f) with (pages_per_range=1);
set enable_seqscan=off; set enable_indexscan=off;
select count(*) from t where f <= 1.98::float4;
select count(*) from t where f >= 100.5::float4;
