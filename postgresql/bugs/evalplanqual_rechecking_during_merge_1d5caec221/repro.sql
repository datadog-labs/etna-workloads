CREATE TABLE tgt (id int PRIMARY KEY, val int);
CREATE TABLE src (id int PRIMARY KEY, val int);
EXPLAIN (verbose, costs off)
MERGE INTO tgt USING src ON tgt.id = src.id
  WHEN MATCHED THEN UPDATE SET val = src.val
  WHEN NOT MATCHED THEN INSERT VALUES (src.id, src.val);
