CREATE FUNCTION f() RETURNS event_trigger LANGUAGE plpgsql AS $$
DECLARE r record;
BEGIN
 FOR r IN SELECT * FROM pg_event_trigger_ddl_commands() LOOP
  RAISE NOTICE 'END: % % %', r.command_tag, r.object_type, r.object_identity;
 END LOOP;
END $$;
CREATE EVENT TRIGGER t ON ddl_command_end EXECUTE FUNCTION f();
CREATE OPERATOR CLASS evttrigopclass FOR TYPE int USING btree AS STORAGE int;
