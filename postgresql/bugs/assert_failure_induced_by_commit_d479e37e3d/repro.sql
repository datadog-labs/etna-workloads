create temp table t(q1 int8, q2 int8);
insert into t values (1,2),(2,2);
explain (costs off)
select * from (select *, 0 as x from t a union all select *, 1 as x from t b) ss
where (x = 0) or (q1 >= q2 and q1 <= q2);
select * from (select *, 0 as x from t a union all select *, 1 as x from t b) ss
where (x = 0) or (q1 >= q2 and q1 <= q2);
