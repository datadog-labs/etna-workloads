create table matest0(a int primary key);
create table matest1() inherits (matest0);
insert into matest0 select generate_series(1, 400);
insert into matest1 select generate_series(1, 200);
analyze matest0;
analyze matest1;
explain (costs off)
select * from matest0 where a < 100 order by a;
