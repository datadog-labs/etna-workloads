create table p (a int default 1, b int not null default 0) partition by list (a);
create table p1 partition of p (a not null, b default 1) for values in (1);
insert into p (b) values (null);
\d p1
create table p2 partition of p (b not null, b default 1) for values in (2);
create table p3 partition of p (zz not null) for values in (3);
drop table p;
