.mode list
.nullvalue NULL
CREATE TABLE window_input(p INTEGER, id INTEGER, x INTEGER);
INSERT INTO window_input VALUES (1, 1, 10), (1, 2, 20), (1, 3, 30), (1, 4, 40);
CREATE SEQUENCE qualify_sequence START 1;
SELECT p, id, x, SUM(x) OVER (PARTITION BY p) AS partition_sum
FROM window_input
QUALIFY nextval('qualify_sequence') <= 2
ORDER BY id;
