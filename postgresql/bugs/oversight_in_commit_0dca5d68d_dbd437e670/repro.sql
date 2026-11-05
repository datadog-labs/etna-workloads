SET check_function_bodies = off;
CREATE FUNCTION test1 (anyelement) RETURNS anyarray LANGUAGE SQL AS '';
SELECT test1(0);
