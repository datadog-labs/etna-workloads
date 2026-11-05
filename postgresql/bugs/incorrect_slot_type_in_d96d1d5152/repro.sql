create temp table t1 as select i, 'x'||i as s from generate_series(1,2000) i;
create temp table t2 as select * from t1 where i % 2 = 0;
set enable_sort=off;
select count(*) from (select * from t1 except select * from t2) x;
with recursive r(a,b) as (select i, s from t1 where i<5 union select a, b from r where false) select * from r order by 1;
with recursive r(a,b) as (select i, s from t1 where i<5 union select a+1, b from r where a<10) select count(*) from r;
