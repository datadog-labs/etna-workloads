CREATE SEQUENCE s;
CREATE TABLE t2 (a int);
INSERT INTO t2 VALUES (1),(2),(3);
ALTER TABLE t2 ADD COLUMN b int DEFAULT nextval('s');
SELECT * FROM t2;
SELECT atthasmissing FROM pg_attribute WHERE attrelid='t2'::regclass AND attname='b';
