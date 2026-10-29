CREATE TABLE dual(dummy); INSERT INTO dual(dummy) VALUES('X');
CREATE TABLE t3(a TEXT,b TEXT,c TEXT,d TEXT,e TEXT,f TEXT);
CREATE INDEX t3x ON t3(b,c,d,e,f);
SELECT a FROM t3
  WHERE (c,d) IN (SELECT 'c','d' FROM dual)
  AND (a,b,e) IN (SELECT 'a','b','d' FROM dual);
