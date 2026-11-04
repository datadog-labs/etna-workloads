create table t(a int, b int) as values (1,3), (3,4), (4,5);
select a from t group by a order by min(b);
select a from t group by a order by min(b) + max(b) desc;
