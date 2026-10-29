SELECT xyz.* FROM (JSON_EACH('{"a":1, "b":2}')) AS xyz;
SELECT * FROM (generate_series(1,5,2)) AS x LIMIT 10;
