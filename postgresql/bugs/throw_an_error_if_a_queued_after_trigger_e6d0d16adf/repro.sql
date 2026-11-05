create table refd_table (id int primary key);
create table trig_table (fk int references refd_table initially deferred);
begin;
insert into trig_table values (1);
drop table refd_table cascade;
commit;
select 'committed' as result;
drop table trig_table;
