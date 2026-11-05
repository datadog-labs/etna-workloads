CREATE TABLE test2(x int);
INSERT INTO test2 VALUES(42);
CREATE FUNCTION report_count() RETURNS int STABLE LANGUAGE sql AS $$ SELECT COUNT(*) FROM test2 $$;
CREATE PROCEDURE p(cnt int) LANGUAGE plpgsql AS $$ BEGIN RAISE NOTICE 'count = %', cnt; END $$;
DO $$
BEGIN
    CALL p(report_count());
    INSERT INTO test2 VALUES(43);
    CALL p(report_count());
END
$$;
