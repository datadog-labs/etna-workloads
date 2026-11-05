CREATE FUNCTION amb_f(int) RETURNS int LANGUAGE sql AS 'select 1';
CREATE FUNCTION amb_f(text) RETURNS int LANGUAGE sql AS 'select 1';
DROP FUNCTION IF EXISTS amb_f;
DROP FUNCTION amb_f(int);
DROP FUNCTION amb_f(text);
