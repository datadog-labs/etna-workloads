CREATE VIRTUAL TABLE t1 USING fts4(poiCategory, poiCategoryId, notindexed=poiCategoryId);
INSERT INTO t1(poiCategory, poiCategoryId) VALUES ('Restaurant', 6021);
SELECT 'restaurant', count(*) FROM t1 WHERE t1 MATCH 'restaurant';
SELECT '6021', count(*) FROM t1 WHERE t1 MATCH '6021';
