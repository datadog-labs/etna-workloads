create table p(a int, b int);
create table c(x int, b int, a int);
alter table c inherit p;
alter table c drop column x;
alter table c add column z int;
explain (verbose, costs off) select * from p as t(u,v);
create table c2(b int, a int) ;
alter table c2 inherit p;
explain (verbose, costs off) select * from p as t(u,v);
