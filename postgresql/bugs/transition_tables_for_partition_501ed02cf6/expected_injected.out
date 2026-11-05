create table parent (a text) partition by list (a);
create table child (a text);
create function dump_insert() returns trigger language plpgsql as $$ begin return null; end $$;
create trigger child_row_trig after insert on child referencing new table as new_table
  for each row execute procedure dump_insert();
alter table parent attach partition child for values in ('AAA');
create table p2 (a text);
create table c2 (a text);
create trigger c2_trig after insert on c2 referencing new table as new_table
  for each row execute procedure dump_insert();
alter table c2 inherit p2;
