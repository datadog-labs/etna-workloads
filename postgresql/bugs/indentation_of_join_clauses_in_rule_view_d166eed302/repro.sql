create temp table a(i int, j int);
create temp table b(i int, j int);
create temp table c(i int, j int);
create view v as select a.i, c.j from a join b on a.i=b.i left join c on b.j=c.j where a.j>1;
select pg_get_viewdef('v'::regclass, true);
