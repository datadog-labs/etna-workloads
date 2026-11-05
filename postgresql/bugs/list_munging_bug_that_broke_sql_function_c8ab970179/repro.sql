create type rt as (f1 numeric(10,6), f2 numeric(4,2));
create function t1() returns setof rt as $$
  select 1, 2 union select 3, 4 order by 1;
$$ language sql immutable;
select t1();
select * from t1();
create function t2() returns int8 as $$ select 1::int4 union select 2::int4 order by 1 limit 1 $$ language sql;
select t2();
