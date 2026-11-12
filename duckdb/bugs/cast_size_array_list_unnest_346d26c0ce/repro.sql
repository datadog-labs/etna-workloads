.mode list
.nullvalue NULL
SET threads=1;
CREATE TABLE m(id INT, fixed INT[2]);
INSERT INTO m VALUES (1, [1, 2]), (2, [3, 4]), (3, NULL);
SELECT * FROM m, UNNEST(m.fixed) AS s(v) ORDER BY ALL;
