create table t(a int, b int);
create index on t(a,b);
set enable_seqscan=off;
explain (costs off) select * from t where a=42 and (b=1 or b=3 or b=0);
