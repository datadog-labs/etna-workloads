create table atacc1 (id serial primary key, value int check (value < 10));
alter table atacc1 drop column value;
alter table atacc1 add column value int check (value < 10);
insert into atacc1(value) values (100);
insert into atacc1(id, value) values (null, 0);
