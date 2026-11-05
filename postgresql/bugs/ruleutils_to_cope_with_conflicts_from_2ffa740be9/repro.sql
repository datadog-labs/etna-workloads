create table tt7(x int, xx int, y int);
alter table tt7 drop column xx;
create table tt8(x int, z int);
create view vv2 as
select * from (values(1,2,3,4,5)) v(a,b,c,d,e)
union all
select * from tt7 full join tt8 using (x), tt8 tt8x;
select pg_get_viewdef('vv2'::regclass);
create table t1(a int, b int);
create view v1 as select * from t1, t1 t1x;
alter table t1 rename a to b2;
select pg_get_viewdef('v1'::regclass);
