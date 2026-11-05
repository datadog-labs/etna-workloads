create temp table t(f1 int);
insert into t values (0),(1),(2);
analyze t;
explain (costs off)
select * from t o where (f1, f1) in
  (select f1, generate_series(1,50) / 10 g from t i group by f1);
