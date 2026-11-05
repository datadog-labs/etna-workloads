create temp table t(q1 int);
explain (costs off)
select * from t t1 left join t t2 on true
 left join lateral (select t2.q1 from t t3) s on t2.q1 = 1;
