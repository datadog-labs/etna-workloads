create table t as select g%4 as four from generate_series(1,100) g;
select x, y from (select four as x, four as y from t) as t
  group by grouping sets (x, y) having y is null order by 1, 2;
select x, y || 'y' from (select four as x, four as y from t) as t
  group by grouping sets (x, y) order by 1, 2;
