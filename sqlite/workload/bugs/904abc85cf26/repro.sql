CREATE TABLE parent (id TEXT PRIMARY KEY);
CREATE TABLE child_a (id TEXT);
CREATE TABLE child_b (id TEXT);
INSERT INTO parent VALUES ('p1');
INSERT INTO child_a VALUES ('p1');
SELECT count(*), parent.id FROM parent
 WHERE EXISTS (
    SELECT 1 FROM child_a WHERE child_a.id = parent.id
    UNION
    SELECT 1 FROM child_b WHERE child_b.id = parent.id
 )
 GROUP BY id;
