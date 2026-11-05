CREATE TABLE pred_parent (a int);
CREATE TABLE pred_child () INHERITS (pred_parent);
ALTER TABLE ONLY pred_parent ALTER a SET NOT NULL;
INSERT INTO pred_child VALUES (NULL), (1);
SELECT count(*) FROM pred_parent WHERE a IS NULL;
EXPLAIN (COSTS OFF) SELECT * FROM pred_parent WHERE a IS NOT NULL;
EXPLAIN (COSTS OFF) SELECT * FROM pred_parent WHERE a IS NULL;
