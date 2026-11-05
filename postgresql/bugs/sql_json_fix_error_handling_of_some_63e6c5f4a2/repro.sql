CREATE DOMAIN d AS text CHECK (value <> 'foo');
SELECT JSON_VALUE(jsonb '{"d1": "H"}', '$.a2' RETURNING d DEFAULT 'foo'::d ON EMPTY);
