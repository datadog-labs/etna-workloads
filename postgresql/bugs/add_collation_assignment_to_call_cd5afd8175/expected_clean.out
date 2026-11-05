CREATE PROCEDURE ptest7(a text, b text)
LANGUAGE SQL
AS $$
SELECT a = b;
$$;
CALL ptest7(least('a', 'b'), 'a');
