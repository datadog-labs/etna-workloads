CREATE TABLE pk (tid int, id int, PRIMARY KEY (tid, id));
CREATE TABLE fk (tid int, id int, a int, b int DEFAULT 0,
  FOREIGN KEY (tid, b) REFERENCES pk ON DELETE SET DEFAULT (b, b));
SELECT pg_get_constraintdef(oid) FROM pg_constraint WHERE conrelid='fk'::regclass;
INSERT INTO pk VALUES (1,0),(1,2);
INSERT INTO fk VALUES (1,1,1,2);
DELETE FROM pk WHERE id=2;
SELECT * FROM fk;
