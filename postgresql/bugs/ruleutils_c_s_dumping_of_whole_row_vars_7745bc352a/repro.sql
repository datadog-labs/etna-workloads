create table t(a int, b int);
create type nc as (x t);
create view v1 as select row(i)::nc from t i;
select pg_get_viewdef('v1', true);
create view v2 as select * from t i, lateral(values(i)) ss;
select pg_get_viewdef('v2', true);
