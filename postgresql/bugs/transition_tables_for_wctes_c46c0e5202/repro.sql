create table table1(a int);
create table table2(a text);
create function dump_insert() returns trigger language plpgsql as $$
begin raise notice 'trigger = %, new table = %', tg_name,
 (select string_agg(new_table::text, ', ' order by a) from new_table);
 return null; end $$;
create trigger table1_trig after insert on table1 referencing new table as new_table for each statement execute procedure dump_insert();
create trigger table2_trig after insert on table2 referencing new table as new_table for each statement execute procedure dump_insert();
with wcte as (insert into table1 values (42)) insert into table2 values ('hello world');
select * from table1;
select * from table2;
