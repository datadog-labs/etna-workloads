CREATE TABLE test1(a int);
CREATE PROCEDURE p() LANGUAGE plpgsql AS $$
  DECLARE id int;
  BEGIN
    FOR id IN SELECT 1/(x-1000) FROM generate_series(1,1000) x LOOP
        INSERT INTO test1 VALUES(id);
        COMMIT;
    END LOOP;
  END;
$$;
CALL p();
SELECT count(*) FROM test1;
