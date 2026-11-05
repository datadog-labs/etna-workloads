create table attbl (p1 int constraint pk_attbl primary key);
create table atref (c1 int references attbl(p1));
cluster attbl using pk_attbl;
alter table attbl alter column p1 set data type bigint;
alter table atref alter column c1 set data type bigint;
