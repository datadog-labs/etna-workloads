.mode list
.nullvalue NULL
CREATE TABLE tbl (
	g AS (x + 1),
	x INTEGER,
	y INTEGER UNIQUE
);
INSERT INTO tbl VALUES (1, 10);
INSERT OR REPLACE INTO tbl (x, y) VALUES (2, 10);
SELECT * FROM tbl;
