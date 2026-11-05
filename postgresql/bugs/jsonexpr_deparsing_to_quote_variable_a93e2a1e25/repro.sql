CREATE VIEW v AS SELECT JSON_EXISTS(jsonb '{"a":1}', '$.a' PASSING 1 AS "Xyz", 2 AS "int");
SELECT pg_get_viewdef('v'::regclass);
