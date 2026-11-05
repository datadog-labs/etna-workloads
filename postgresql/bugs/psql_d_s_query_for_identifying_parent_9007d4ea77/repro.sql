create function trigger_nothing() returns trigger language plpgsql as $$ begin return null; end $$;
create table trigpart (a int, b int) partition by range (a);
create table trigpart1 partition of trigpart for values from (0) to (1000);
create trigger trg1 after insert on trigpart for each row execute function trigger_nothing();
create trigger samename after delete on trigpart execute function trigger_nothing();
create trigger samename after delete on trigpart1 execute function trigger_nothing();
\d trigpart1
