CREATE FUNCTION f() RETURNS event_trigger LANGUAGE plpgsql AS $$
DECLARE o record;
BEGIN
 FOR o IN SELECT * FROM pg_event_trigger_dropped_objects() LOOP
  RAISE NOTICE '% | % | % | %', o.object_type, o.object_name, o.is_temporary, o.object_identity;
 END LOOP;
END $$;
CREATE EVENT TRIGGER t ON sql_drop EXECUTE FUNCTION f();
CREATE SCHEMA s1;
DROP SCHEMA s1;
CREATE TEMP TABLE tt(a int default 1);
CREATE TRIGGER tg BEFORE INSERT ON tt FOR EACH ROW EXECUTE FUNCTION suppress_redundant_updates_trigger();
DROP TABLE tt;
