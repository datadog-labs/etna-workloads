CREATE EXTENSION IF NOT EXISTS plpython3u;
CREATE TABLE recursive_trigger_test (a int, b int);
CREATE FUNCTION recursive_trigger_func() RETURNS trigger
LANGUAGE plpython3u
AS $$
if TD["event"] == "UPDATE":
    plpy.execute("INSERT INTO recursive_trigger_test VALUES (1, 2)")
    plpy.notice("TD[event] => " + str(TD["event"]) + ", expecting UPDATE");
else:
    plpy.notice("TD[event] => " + str(TD["event"]) + ", expecting INSERT");
return None
$$;
CREATE TRIGGER recursive_trigger_trig
  AFTER INSERT OR UPDATE ON recursive_trigger_test
  FOR EACH ROW EXECUTE PROCEDURE recursive_trigger_func();
INSERT INTO recursive_trigger_test VALUES (0, 0);
UPDATE recursive_trigger_test SET a = 11 WHERE b = 0;
