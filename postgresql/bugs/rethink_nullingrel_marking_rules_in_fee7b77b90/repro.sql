create temp table t(f1 int);
insert into t values (1);
explain (costs off)
select * from t t1 left join t t2 on true
  left join t t3 on t2.f1 > 0
  left join t t4 on t3.f1 > 0;
