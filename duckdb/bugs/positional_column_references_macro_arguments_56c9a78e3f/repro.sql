.mode list
.nullvalue NULL
CREATE MACRO subtract_args(x, y) AS x - y;
SELECT subtract_args(#1, #2), #1 - #2
FROM (VALUES (10, 3)) AS t(y, x);
