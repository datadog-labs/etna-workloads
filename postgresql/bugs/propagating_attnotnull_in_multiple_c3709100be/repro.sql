create table pp1 (f1 int);
create table cc1 (f2 text, f3 int) inherits (pp1);
create table cc2(f4 float) inherits(pp1,cc1);
create table cc3() inherits(pp1,cc1,cc2);
alter table pp1 alter f1 set not null;
\d+ cc3
drop table pp1 cascade;
