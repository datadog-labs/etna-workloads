CREATE TABLE fd (a int, b text);
INSERT INTO fd SELECT i/100, (i/400)::text FROM generate_series(0,9999) i;
CREATE STATISTICS s (dependencies) ON a, b FROM fd;
ANALYZE fd;
CREATE FUNCTION est(q text) RETURNS int LANGUAGE plpgsql AS $$
DECLARE r text; BEGIN
FOR r IN EXECUTE 'EXPLAIN '||q LOOP RETURN substring(r from 'rows=(\d+)')::int; END LOOP; END $$;
SELECT est('SELECT * FROM fd WHERE a IN (0,1,2,3,4,5,6,7) AND b = ''0''');
