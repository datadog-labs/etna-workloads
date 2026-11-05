create table tt14t (f1 text, f2 text, f3 text, f4 int);
create function tt14f() returns setof tt14t as $$ select * from tt14t $$ language sql;
create view tt14v as select t.f1, t.f4 from tt14f() t;
alter table tt14t drop column f3;
select pg_get_viewdef('tt14v', true);
