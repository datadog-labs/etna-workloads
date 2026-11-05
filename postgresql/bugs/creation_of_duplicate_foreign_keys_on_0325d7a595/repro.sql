create schema fkpart0
  create table pkey (a int primary key)
  create table fk_part (a int) partition by list (a)
  create table fk_part_1 partition of fk_part
      (foreign key (a) references fkpart0.pkey) for values in (1);
alter table fkpart0.fk_part add foreign key (a) references fkpart0.pkey;
select conrelid::regclass, conname from pg_constraint where contype='f' and connamespace='fkpart0'::regnamespace order by 1,2;
alter table fkpart0.fk_part_1 drop constraint fk_part_1_a_fkey;
