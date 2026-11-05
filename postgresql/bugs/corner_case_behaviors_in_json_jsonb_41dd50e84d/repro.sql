SELECT '[1,2]'::jsonb -> 'x' AS a;
SELECT '5'::jsonb ->> 'x' AS b;
SELECT '{"a":1}'::jsonb -> 2 AS c;
SELECT '"s"'::jsonb ->> 2 AS d;
