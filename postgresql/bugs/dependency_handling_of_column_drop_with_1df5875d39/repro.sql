create table p(a int, b int, c int) partition by list (a);
create table p1 partition of p for values in (1) partition by list (a);
create table p2 partition of p for values in (2) partition by list (a);
create table p11 partition of p1 for values in (1);
create index on p (b);
create index on p (c);
create index on p (b, c);
alter table p drop column c;
\d p
\d p1
\d p2
\d p11
drop table p;
