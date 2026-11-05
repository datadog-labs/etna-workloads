create temp table t(a int);
insert into t values (1),(2);
select min(a), min(a) from t;
select min(a) from t;
