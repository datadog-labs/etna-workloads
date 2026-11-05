\set VERBOSITY verbose
create table parted_trig (a int) partition by list (a);
create function trigger_nothing() returns trigger language plpgsql as $$begin return null; end$$;
create trigger failed after update on parted_trig
  referencing old table as old_table
  for each row execute procedure trigger_nothing();
