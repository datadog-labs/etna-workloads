SELECT JSON_VALUE(jsonb '{"a":1}', '$.b' RETURNING text DEFAULT '"x"'::jsonb::text ON ERROR);
SELECT JSON_VALUE(jsonb '{"a":1}', '$.b' RETURNING text DEFAULT 'x'::varchar ON EMPTY);
SELECT JSON_VALUE(jsonb '{"a":1}', '$.b' RETURNING text DEFAULT (SELECT 'x') ON EMPTY);
