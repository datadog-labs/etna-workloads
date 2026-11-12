.mode list
.nullvalue NULL
FROM (VALUES (1,1,2),(1,1,3)) AS t(key1,key2,v)
SELECT DISTINCT ON (COLUMNS('key')) *;
