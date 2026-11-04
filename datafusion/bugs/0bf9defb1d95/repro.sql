CREATE TABLE dup_filter_t1(id INTEGER) AS VALUES (1), (2), (3);
CREATE TABLE dup_filter_t2(id INTEGER) AS VALUES (1), (2), (3);
SELECT * FROM dup_filter_t1 WHERE dup_filter_t1.id IN (
    SELECT dup_filter_t2.id FROM dup_filter_t2 WHERE dup_filter_t2.id > dup_filter_t1.id
);
CREATE TABLE sq_name_t1(id INTEGER) AS VALUES (1), (2), (3);
CREATE TABLE sq_name_t2(id INTEGER, outer_id INTEGER) AS VALUES (10, 1), (20, 1), (30, 2);
SELECT sq_name_t1.id,
  (SELECT count(*) AS id FROM sq_name_t2 WHERE sq_name_t2.outer_id = sq_name_t1.id) AS cnt
FROM sq_name_t1 ORDER BY sq_name_t1.id;
SELECT sq_name_t1.id FROM sq_name_t1
WHERE sq_name_t1.id > (SELECT count(*) AS id FROM sq_name_t2 WHERE sq_name_t2.outer_id = sq_name_t1.id)
ORDER BY sq_name_t1.id;
