create table p (a int, b int) partition by range (a);
create table p1 partition of p for values from (1) to (2) partition by range (b);
create table p11 partition of p1 for values from (1) to (10);
insert into p1 (a, b) values (2, 3);
select * from p;
