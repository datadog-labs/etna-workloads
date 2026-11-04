SET datafusion.execution.target_partitions = 4;
CREATE TABLE nai_outer(id INT) AS VALUES (3), (7);
CREATE TABLE nai_inner(id INT) AS VALUES (NULL);
SELECT id FROM nai_outer WHERE id > 5 AND id NOT IN (SELECT id FROM nai_inner) ORDER BY id;
