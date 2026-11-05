CREATE FUNCTION t() RETURNS event_trigger LANGUAGE plpgsql AS $$
DECLARE r record;
BEGIN
 FOR r IN SELECT * FROM pg_event_trigger_ddl_commands() LOOP
  RAISE NOTICE 'tag %, type %', r.command_tag, r.object_type;
 END LOOP;
END $$;
CREATE EVENT TRIGGER et ON ddl_command_end EXECUTE FUNCTION t();
CREATE TRANSFORM FOR int LANGUAGE SQL (
    FROM SQL WITH FUNCTION prsd_lextype(internal),
    TO SQL WITH FUNCTION int4recv(internal));
DROP TRANSFORM FOR int LANGUAGE SQL;
