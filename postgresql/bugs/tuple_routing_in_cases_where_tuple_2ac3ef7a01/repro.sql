create table p (a int, b int, c text) partition by range (a);
create table p1 (c text, a int, b int) partition by range (b);
alter table p attach partition p1 for values from (0) to (100);
create table p11 (c text, a int, b int);
alter table p1 attach partition p11 for values from (0) to (10);
insert into p values (5, 5, 'x');
insert into p values (50, 5, 'y');
select * from p order by 1;
