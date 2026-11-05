create table t(a int);
create domain dt as t;
create table u(f dt);
alter table t alter column a type bigint;
create table t2(a int);
create type r as range (subtype = int4);
create domain d2 as t2[];
create table u2(f d2);
alter table t2 alter column a type bigint;
