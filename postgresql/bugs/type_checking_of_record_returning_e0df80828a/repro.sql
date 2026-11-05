create temp table t(x int);
insert into t values (1);
select * from t, coalesce(row(1)) as (a int, b int);
