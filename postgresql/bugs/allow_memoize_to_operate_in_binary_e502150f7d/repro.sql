create table t1 as select (case when i%2=0 then 0.0 else -0.0 end)::float8 x from generate_series(1,10) i;
create table t2 as select 1 id;
analyze t1; analyze t2;
set enable_hashjoin=off; set enable_mergejoin=off; set enable_nestloop=on;
set enable_material=off;
explain (costs off) select t1.x::text, s.v from t1, lateral (select (t1.x::text) v from t2 offset 0) s;
select t1.x::text, s.v from t1, lateral (select (t1.x::text) v from t2 where t1.x=0 offset 0) s;
