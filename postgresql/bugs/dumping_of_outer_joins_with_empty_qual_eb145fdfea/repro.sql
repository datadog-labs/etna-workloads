create table t5(a int);
create table t6(d int);
create view v as select * from t5 natural left join t6;
select pg_get_viewdef('v', true);
