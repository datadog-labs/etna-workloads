CREATE TABLE test1 (a int, b text);
INSERT INTO test1 VALUES (1,'one'), (2,'two'), (3,'three');
DO LANGUAGE plpgsql $$
DECLARE r RECORD;
BEGIN
    FOR r IN SELECT a FROM test1 FOR UPDATE LOOP
      UPDATE test1 SET b = b || ' ' || b WHERE a = r.a;
      COMMIT;
    END LOOP;
END;
$$;
SELECT * FROM test1 ORDER BY a;
