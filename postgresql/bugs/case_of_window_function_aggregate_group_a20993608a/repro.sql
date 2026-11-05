create temp table t as select g as x, g%10 as ten, g%4 as four from generate_series(1,100) g;
select first_value(max(x)) over (), y
  from (select x, ten+four as y from t) ss
  group by y order by y limit 3;
