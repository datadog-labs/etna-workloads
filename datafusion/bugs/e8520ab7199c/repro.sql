SET datafusion.explain.format = 'indent';
create table t1(t1_id int, t1_int int);
explain select t1_id, i from t1 cross join lateral (select * from unnest(generate_series(1, t1_int))) as series(i);
