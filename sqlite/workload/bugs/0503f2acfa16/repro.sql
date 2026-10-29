ATTACH ':memory:' AS aux1;
CREATE TABLE main.x3(x,y,z);
INSERT INTO x3 VALUES(1,'main',1),(2,'aux1',1);
SELECT pgno, schema, substr(data,1,6)
  FROM sqlite_dbpage, x3
 WHERE sqlite_dbpage.schema=x3.y AND sqlite_dbpage.pgno=x3.z
 ORDER BY x3.x;
