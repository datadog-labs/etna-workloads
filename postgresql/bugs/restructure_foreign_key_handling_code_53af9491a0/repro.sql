create schema fkpart1
  create table pkey (a int primary key)
  create table fk_part (a int) partition by list (a)
  create table fk_part_1 partition of fk_part for values in (1) partition by list (a)
  create table fk_part_1_1 partition of fk_part_1 for values in (1);
alter table fkpart1.fk_part add foreign key (a) references fkpart1.pkey;
insert into fkpart1.pkey values (1);
insert into fkpart1.fk_part values (1);
alter table fkpart1.fk_part detach partition fkpart1.fk_part_1;
delete from fkpart1.pkey where a = 1;
