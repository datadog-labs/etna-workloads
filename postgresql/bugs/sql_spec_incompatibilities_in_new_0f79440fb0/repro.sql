create table my_table (a int, b int);
create function dump_insert() returns trigger language plpgsql as $$ begin return null; end $$;
create trigger t after update of b on my_table referencing new table as new_table
  for each statement execute procedure dump_insert();
select count(*) from pg_trigger where tgrelid='my_table'::regclass;
