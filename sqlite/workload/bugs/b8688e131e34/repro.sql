CREATE TABLE t1(a,b,c,d);
CREATE TABLE t2(a,b,c,d,x);
CREATE TRIGGER r1 AFTER INSERT ON t2 BEGIN
  SELECT unknown_function(a ORDER BY (SELECT group_concat(a ORDER BY a) FROM (SELECT b FROM t1))) FROM t1;
END;
ALTER TABLE t2 RENAME TO e;
SELECT name, type FROM sqlite_schema ORDER BY name;
