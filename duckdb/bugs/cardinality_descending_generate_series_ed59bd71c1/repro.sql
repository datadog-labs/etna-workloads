.mode list
.nullvalue NULL
SELECT * FROM range(0, 10, 1);
CALL range(10);
SELECT * FROM generate_series(0, 10, 1);
SELECT * FROM range(10, 0, -1) ORDER BY 1 ASC;
SELECT * FROM generate_series(10, 0, -1) ORDER BY 1 ASC;
SELECT * FROM generate_series(5, 1, -1) LIMIT 4;
