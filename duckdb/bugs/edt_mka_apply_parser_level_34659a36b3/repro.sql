.mode list
.nullvalue NULL
SELECT (3).ifnull(5);
SELECT (NULL::INTEGER).ifnull(5);
SELECT ifnull(NULL::INTEGER, 5);
SELECT ['abc'].ifnull(['def']);
SELECT ['abc'].ifnull(NULL);
SELECT (NULL::VARCHAR).ifnull('x').ifnull('y');
SELECT (3).nullif(3);
SELECT ('abc'::INTEGER).try();
