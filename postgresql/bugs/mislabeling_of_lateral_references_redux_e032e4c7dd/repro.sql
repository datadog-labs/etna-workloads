create table t(q1 int8, q2 int8);
insert into t values (1,2),(3,2),(4,5);
analyze t;
select t1.q1, x from
  t t1 left join
  (t t2 left join
   lateral (select t2.q1+t3.q1 as x, * from t t3) t3 on t2.q2 = t3.q2)
  on t1.q2 = t2.q2
order by 1, 2;
