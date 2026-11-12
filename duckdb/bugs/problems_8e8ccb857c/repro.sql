.mode list
.nullvalue NULL
CREATE SEQUENCE id_sequence START 1;
CREATE TABLE tbl (id INTEGER DEFAULT nextval('id_sequence'), s VARCHAR);
INSERT INTO tbl(s) VALUES ('default is sequence');
ALTER TABLE tbl ALTER COLUMN id SET DEFAULT NULL;
INSERT INTO tbl(s) VALUES ('default is NULL');
SELECT * FROM tbl;
DROP SEQUENCE id_sequence;
CREATE SEQUENCE seq START 1;
CREATE TABLE tbl2 (
	a INTEGER DEFAULT nextval('seq'),
	b INTEGER DEFAULT nextval('seq')
);
INSERT INTO tbl2 DEFAULT VALUES;
