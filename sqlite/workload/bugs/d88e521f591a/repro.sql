.open file:memdb1?mode=memory&cache=shared
CREATE VIRTUAL TABLE ft USING fts3;
INSERT INTO ft VALUES('hello world');
SELECT * FROM ft;
.connection 1
.open file:memdb1?mode=memory&cache=shared
DROP TABLE ft;
.connection close 0
SELECT 'done';
