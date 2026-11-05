BEGIN;
CREATE DOMAIN foodomain AS text;
CREATE FUNCTION volfoo(text) RETURNS foodomain AS 'begin return $1::foodomain; end' LANGUAGE plpgsql VOLATILE;
CREATE FUNCTION inline_eq(foodomain, foodomain) RETURNS boolean AS 'SELECT CASE $2::text WHEN $1::text THEN true ELSE false END' LANGUAGE sql;
CREATE OPERATOR = (procedure = inline_eq, leftarg = foodomain, rightarg = foodomain);
SELECT CASE volfoo('bar') WHEN 'foo'::foodomain THEN 'is foo' ELSE 'is not foo' END;
ROLLBACK;
