CREATE VIRTUAL TABLE temp.zip USING zipfile('test.zip');
INSERT INTO temp.zip (name,data) VALUES ('test1','test');
INSERT INTO temp.zip (name,data) VALUES ('test2','test');
UPDATE OR REPLACE zip SET name='test2' WHERE name='test1';
SELECT name FROM zip;
