create table p (a int, ref int) partition by range (a);
create table p1 partition of p for values from (0) to (10);
alter table p add constraint c check (a >= 0);
select conname from pg_constraint where conrelid='p1'::regclass;
create table s(id int, ref_id int);
alter table s add primary key (id), add foreign key (ref_id) references s;
