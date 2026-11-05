CREATE VIEW v AS SELECT JSON_QUERY('[1,2]'::jsonb, '$[*]' RETURNING jsonb WITH UNCONDITIONAL WRAPPER) AS x;
SELECT pg_get_viewdef('v'::regclass);
