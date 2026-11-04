create table t(a int) as values (1), (2), (3), (1);
select *, count(*) over() as ta from t order by a;
select *, a + 1 as b from t order by a;
