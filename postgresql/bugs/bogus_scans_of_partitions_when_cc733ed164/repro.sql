create table pk (a int primary key) partition by list (a);
create table pk1 partition of pk for values in (1);
create table pk2 partition of pk for values in (2);
insert into pk values (1),(2);
create table fk (a int);
insert into fk values (1),(2);
alter table fk add foreign key (a) references pk not valid;
alter table fk validate constraint fk_a_fkey;
select convalidated from pg_constraint where conrelid='fk'::regclass;
