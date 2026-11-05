create table a(x int primary key);
create table b(x int, y int);
create table c(z int);
create function f_field_select(t b) returns int4 as
$$ select t.y; $$ language sql immutable;
select (t2.*).x, f_field_select(t2) from a t1
    left join b t2 on t1.x = t2.x
    left join c t3 on true;
