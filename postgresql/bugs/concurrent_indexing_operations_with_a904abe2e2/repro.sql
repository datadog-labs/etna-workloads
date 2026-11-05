create temp table t(a int) on commit delete rows;
create index concurrently i on t(a);
reindex index concurrently i;
drop index concurrently i;
create temp table t2(a int) on commit drop;
create index concurrently i2 on t2(a);
