create table t(j jsonb);
insert into t values ('{"a":{"b":1}}'), ('{"b":2}');
create index on t using gin(j);
set enable_seqscan=off;
select * from t where j ? 'b' order by j::text;
select * from t where j ?| array['b'] order by j::text;
select * from t where j ?& array['b'] order by j::text;
