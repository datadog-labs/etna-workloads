create table t(p point);
insert into t select point(i,i) from generate_series(1,100) i;
create index on t using gist(p);
set enable_seqscan=off; set enable_bitmapscan=off;
select p from t order by point(5,5) <-> p limit 3;
select p from t order by p <-> point(5,5) limit 3;
