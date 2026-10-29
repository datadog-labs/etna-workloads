.dbconfig defensive off
CREATE VIRTUAL TABLE t1 USING fts4(content);
DELETE FROM t1_segments;
DELETE FROM t1_segdir;
INSERT INTO t1_segdir (level, idx, start_block, leaves_end_block, end_block, root)
VALUES(0, 0, 0, 0, 0, X'000568656C6C6F08010201FFFFFF7F00');
CREATE VIRTUAL TABLE t1_terms USING fts4aux(t1);
SELECT * FROM t1_terms;
