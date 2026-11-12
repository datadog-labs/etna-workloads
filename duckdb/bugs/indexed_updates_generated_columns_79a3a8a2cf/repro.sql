.mode list
.nullvalue NULL
CREATE TABLE tbl_comp (
	a INT,
	gen AS (2 * a),
	b INT,
	c VARCHAR,
	PRIMARY KEY(c));
INSERT INTO tbl_comp VALUES (1, 1, 'hello');
UPDATE tbl_comp SET c='world';
FROM tbl_comp;
CREATE TABLE tbl_only_indexed (
	gen AS (y + 1),
	y INT UNIQUE
);
INSERT INTO tbl_only_indexed (y) VALUES (10), (20);
BEGIN;
UPDATE tbl_only_indexed SET y = 30 WHERE y = 10;
INSERT INTO tbl_only_indexed (y) VALUES (10);
