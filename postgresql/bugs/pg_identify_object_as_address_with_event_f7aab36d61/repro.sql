CREATE FUNCTION f() RETURNS event_trigger LANGUAGE plpgsql AS $$ BEGIN NULL; END $$;
CREATE EVENT TRIGGER evt_x ON ddl_command_start EXECUTE FUNCTION f();
SELECT b.type, b.object_names, b.object_args,
  pg_identify_object(a.classid, a.objid, a.objsubid) AS ident
FROM pg_event_trigger e,
  LATERAL pg_identify_object_as_address('pg_event_trigger'::regclass, e.oid, 0) b,
  LATERAL pg_get_object_address(b.type, b.object_names, b.object_args) a;
