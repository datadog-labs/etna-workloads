CREATE TABLE idxpart (a INT, b TEXT, c INT) PARTITION BY RANGE(a);
CREATE TABLE idxpart1 PARTITION OF idxpart FOR VALUES FROM (MINVALUE) TO (MAXVALUE);
CREATE INDEX partidx_abc_idx ON idxpart (a, b, c);
INSERT INTO idxpart (a, b, c) SELECT i, i, i FROM generate_series(1, 50) i;
ALTER TABLE idxpart ALTER COLUMN c TYPE numeric;
SELECT count(*) FROM idxpart;
DROP TABLE idxpart;
