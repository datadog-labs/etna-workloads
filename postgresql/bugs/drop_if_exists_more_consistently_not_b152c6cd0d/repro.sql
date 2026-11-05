DROP FUNCTION IF EXISTS no_such_schema.foo(int);
SELECT to_regproc('no_such_schema.now');
