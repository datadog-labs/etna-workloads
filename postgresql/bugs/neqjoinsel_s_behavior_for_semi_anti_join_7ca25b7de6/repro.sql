create table a as select i%2000 as tw, i%5000 as fv, i as t from generate_series(0,9999) i;
create table b as select i%2000 as tw, i%5000 as fv from generate_series(0,9999) i;
create table s as select i as f1 from generate_series(1,5) i;
analyze a; analyze b; analyze s;
explain (summary off)
select * from s, a where exists(select 1 from b where a.tw=b.tw and a.fv<>b.fv) and s.f1=a.t;
