create temp table t1 as select g q1 from generate_series(1,3) g;
create temp table t2 as select g q1, g q2 from generate_series(1,3) g;
create temp table t3 as select g q2 from generate_series(1,3) g;
create temp table t4 as select g q2 from generate_series(1,3) g;
explain (costs off)
select * from t1 left join
  (t2 inner join t3 on false left join t4 on t2.q2 = t4.q2)
on t1.q1 = t2.q1;
select * from t1 left join
  (t2 inner join t3 on false left join t4 on t2.q2 = t4.q2)
on t1.q1 = t2.q1 order by 1;
