create table tt1(x1 int, x2 int, x3 text);
create view v as select x1 as x2, x2 as x1, x3 from tt1 order by x2;
select pg_get_viewdef('v'::regclass);
