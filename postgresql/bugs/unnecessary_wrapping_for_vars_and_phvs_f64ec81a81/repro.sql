create temp table t(q1 int8, q2 int8);
insert into t values (1,2),(2,1);
analyze t;
set enable_nestloop=off;
explain (verbose, costs off)
select t1.q1, x from
  t t1 left join
  (t t2 inner join
   lateral (select t2.q2 as x, * from t t3) ss on t2.q2 = ss.q1)
  on t1.q1 = t2.q1
order by 1, 2;
