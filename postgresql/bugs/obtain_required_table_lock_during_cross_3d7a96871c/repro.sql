create table attbl(a int);
create table atref(b attbl);
create statistics atref_stat on ((b).a is not null) from atref;
alter table attbl alter column a type numeric;
drop statistics atref_stat;
create index atref_idx on atref (((b).a));
alter table attbl alter column a type numeric;
select 1;
