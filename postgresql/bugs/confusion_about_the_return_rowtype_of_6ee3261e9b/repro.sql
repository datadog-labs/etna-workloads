CREATE TABLE int8_tbl(q1 int8, q2 int8);
CREATE PROCEDURE ptest4c(INOUT comp int8_tbl)
LANGUAGE SQL
AS $$
SELECT ROW(1, 2);
$$;
CALL ptest4c(NULL);
