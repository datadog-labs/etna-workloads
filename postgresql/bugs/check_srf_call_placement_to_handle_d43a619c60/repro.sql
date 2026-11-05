create temp table t(a int);
insert into t values(generate_series(1,3));
select * from t order by a;
