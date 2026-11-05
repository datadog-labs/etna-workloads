CREATE PROCEDURE p8(a inout int, b inout int, c inout int = 11)
AS $$ BEGIN RAISE NOTICE 'ran'; END $$ LANGUAGE plpgsql;
DO $$
DECLARE _a int; _b int;
BEGIN
  CALL p8(_a, _b);
END
$$;
