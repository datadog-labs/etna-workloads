create table t(v tsvector);
insert into t values ('foo:1 bar:2'),('bar:1 foo:2'),('baz:1');
create index on t using gist(v);
set enable_seqscan=off;
select * from t where v @@ 'foo <-> bar';
select * from t where v @@ '!(foo <-> bar)' order by v::text;
select * from t where v @@ '!foo' order by v::text;
select * from t where v @@ '!(foo:* <-> bar)' order by v::text;
