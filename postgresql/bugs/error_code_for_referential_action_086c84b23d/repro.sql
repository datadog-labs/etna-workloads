\set VERBOSITY verbose
create table pp(f1 int primary key);
create table cc(f1 int references pp on delete restrict);
insert into pp values(1);
insert into cc values(1);
delete from pp;
