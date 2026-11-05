create temp table t(q1 int8, q2 int8);
insert into t values (123,456),(123,789),(4,5);
select * from (
  select 1 as x, q1, sum(q2)
  from t
  group by grouping sets(1, 2)
) ss
where x = 1 and q1 = 123;
