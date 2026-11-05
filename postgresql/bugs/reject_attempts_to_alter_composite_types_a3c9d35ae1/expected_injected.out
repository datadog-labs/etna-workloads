CREATE TYPE t1 AS (a int, b text);
CREATE TABLE tb (x int, y text);
CREATE INDEX tb_idx ON tb((row(x,y)::t1));
ALTER TYPE t1 ALTER ATTRIBUTE b TYPE varchar;
