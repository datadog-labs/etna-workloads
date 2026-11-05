CREATE FUNCTION alter_op_test_fn(boolean, boolean)
RETURNS boolean AS $$ SELECT NULL::BOOLEAN; $$ LANGUAGE sql IMMUTABLE;
CREATE FUNCTION customcontsel(internal, oid, internal, integer)
RETURNS float8 AS 'contsel' LANGUAGE internal STABLE STRICT;
CREATE OPERATOR === (LEFTARG = boolean, RIGHTARG = boolean, PROCEDURE = alter_op_test_fn, RESTRICT = customcontsel);
ALTER OPERATOR === (boolean, boolean) SET (RESTRICT = NONE);
SELECT pg_describe_object(refclassid,refobjid,refobjsubid) as ref, deptype
FROM pg_depend
WHERE classid = 'pg_operator'::regclass AND objid = '===(bool,bool)'::regoperator
ORDER BY 1;
