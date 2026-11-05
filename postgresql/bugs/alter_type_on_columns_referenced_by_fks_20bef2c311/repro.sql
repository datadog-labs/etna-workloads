CREATE TABLE pk (a int PRIMARY KEY);
CREATE TABLE fk (a int REFERENCES pk(a));
INSERT INTO pk VALUES (1);
INSERT INTO fk VALUES (1);
ALTER TABLE pk ALTER COLUMN a TYPE bigint;
SELECT format_type(atttypid,NULL) FROM pg_attribute WHERE attrelid='pk'::regclass AND attname='a';
