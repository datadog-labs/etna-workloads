create function f() returns event_trigger language plpgsql as $$
declare r record; begin
for r in select * from pg_event_trigger_dropped_objects() loop
raise notice '% % %', r.object_type, r.object_identity, r.is_temporary; end loop; end $$;
create event trigger et on sql_drop execute function f();
create temp table tt(a int default 1);
drop table tt;
