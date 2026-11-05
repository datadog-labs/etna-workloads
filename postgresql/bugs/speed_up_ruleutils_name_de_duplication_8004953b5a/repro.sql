create temp table t18 (a int);
create view tt18v as
  select * from t18 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxy
  union all
  select * from t18 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxz;
select pg_get_viewdef('tt18v', true);
explain (costs off) select * from tt18v;
