create table t(four int, two int, hundred int);
insert into t select i%4, i%2, i from generate_series(1,1000) i;
create index on t(hundred);
analyze t;
explain (costs off) select distinct on (four) four,two from t where four = 0 order by 1;
explain (costs off) select distinct on (four) four,hundred from t where four = 0 order by 1,2;
