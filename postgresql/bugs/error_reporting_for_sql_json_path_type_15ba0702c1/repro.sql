SELECT JSON_QUERY(jsonb '{"a": 123}', ('$' || 'a' || NULL)::date WITH WRAPPER);
CREATE TEMP TABLE jsonpaths (path) AS SELECT '$';
SELECT json_value('"aaa"', jsonpaths RETURNING json) FROM jsonpaths;
