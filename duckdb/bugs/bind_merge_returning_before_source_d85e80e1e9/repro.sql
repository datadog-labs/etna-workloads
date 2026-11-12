.mode list
.nullvalue NULL
CREATE TABLE t(i INTEGER, j INTEGER);
INSERT INTO t VALUES (1, 10), (2, 20);
MERGE INTO t
USING (VALUES (1, 100)) s(i, j)
ON t.i = s.i
WHEN NOT MATCHED BY SOURCE THEN UPDATE SET j = t.j + 1
RETURNING merge_action, j;
