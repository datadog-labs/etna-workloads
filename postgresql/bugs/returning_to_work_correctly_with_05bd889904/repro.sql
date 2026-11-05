create table p (a int, b int) partition by list (a);
create table p1 (x int, b int, a int);
alter table p1 drop column x;
alter table p attach partition p1 for values in (1);
with ins as (insert into p (b, a) values (5, 1) returning tableoid::regclass, *)
  select * from ins;
