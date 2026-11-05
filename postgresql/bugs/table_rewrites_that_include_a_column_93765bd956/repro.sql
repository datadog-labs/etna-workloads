CREATE TABLE rewrite_test(col text);
INSERT INTO rewrite_test VALUES ('something');
INSERT INTO rewrite_test VALUES (NULL);
ALTER TABLE rewrite_test ADD COLUMN empty1 text, ADD COLUMN n1 serial;
ALTER TABLE rewrite_test ADD COLUMN n2 serial, ADD COLUMN empty2 text;
SELECT * FROM rewrite_test;
