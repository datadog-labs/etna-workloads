CREATE TABLE test1 (a int);
CREATE PROCEDURE test_proc4(y int)
LANGUAGE plpgsql
AS $$
BEGIN
    CALL test_proc3(y);
END;
$$;
CREATE PROCEDURE test_proc3(x int)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO test1 VALUES (x);
END;
$$;
CALL test_proc4(66);
CALL test_proc4(66);
SELECT * FROM test1;
