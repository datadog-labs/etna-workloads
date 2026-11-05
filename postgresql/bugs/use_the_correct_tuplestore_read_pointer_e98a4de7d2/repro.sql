CREATE TABLE multi_test (i int);
INSERT INTO multi_test VALUES (1);
CREATE FUNCTION multi_test_trig() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    RAISE NOTICE 'count = %', (SELECT COUNT(*) FROM new_test);
    RAISE NOTICE 'count union = %',
      (SELECT COUNT(*)
       FROM (SELECT * FROM new_test UNION ALL SELECT * FROM new_test) ss);
    RETURN NULL;
END$$;
CREATE TRIGGER my_trigger AFTER UPDATE ON multi_test
  REFERENCING NEW TABLE AS new_test OLD TABLE as old_test
  FOR EACH STATEMENT EXECUTE PROCEDURE multi_test_trig();
UPDATE multi_test SET i = i;
