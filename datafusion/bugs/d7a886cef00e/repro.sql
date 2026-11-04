create table t (a float) as values (1), (null), (3);
select greatest(a is not null, false) from t;
select greatest(a is null, false) from t;
drop table t;
