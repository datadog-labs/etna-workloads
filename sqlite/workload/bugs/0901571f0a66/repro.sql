CREATE TABLE t1(x INT, y TEXT);
INSERT INTO t1(x,y) VALUES(1,'{b:5}');
CREATE INDEX t1j ON t1(nullif(json(y),8));
SELECT json_insert('{}', '$.a', nullif(json(y),8))->>'$.a.b' FROM t1;
