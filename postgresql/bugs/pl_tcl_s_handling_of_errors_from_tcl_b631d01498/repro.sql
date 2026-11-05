CREATE EXTENSION pltcl;
CREATE PROCEDURE test_proc10(INOUT a text)
LANGUAGE pltcl
AS $$
return [list a {$a + $a}])
$$;
CALL test_proc10('abc');
