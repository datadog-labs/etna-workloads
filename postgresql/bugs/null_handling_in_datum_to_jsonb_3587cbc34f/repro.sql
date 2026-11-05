SELECT jsonb_object_agg(1, NULL::jsonb);
SELECT jsonb_object_agg(NULL, '{"a":1}');
