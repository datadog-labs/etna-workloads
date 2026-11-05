create table p(a int);
create table c() inherits (p);
alter table c add constraint k check (a > 0) not valid;
alter table p add constraint k check (a > 0);
create table p2(a int);
create table c2() inherits (p2);
alter table p2 add constraint k check (a > 0);
alter table c2 add constraint k check (a > 0);
select conrelid::regclass, conislocal, coninhcount from pg_constraint where conname='k' order by 1::text;
