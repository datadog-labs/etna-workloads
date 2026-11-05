SELECT JSON_QUERY(jsonb 'null', '$xy' PASSING 1 AS xyz);
SELECT JSON_QUERY(jsonb 'null', '$xyz' PASSING 1 AS xyz);
