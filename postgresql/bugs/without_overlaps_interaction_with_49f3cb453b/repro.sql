CREATE DOMAIN int4range_d AS int4range CHECK (VALUE <> '[10,11)');
CREATE TABLE t4 (id int4range, valid_at int4range_d,
  CONSTRAINT t4_pk UNIQUE (id, valid_at WITHOUT OVERLAPS));
INSERT INTO t4 VALUES ('[1,2)', '[1,13)'), ('[1,2)', '[20,23)');
INSERT INTO t4 VALUES ('[1,2)', '[2,13)');
