CREATE TABLE list_parted (a int, b text) PARTITION BY LIST (a);
CREATE TABLE parent (LIKE list_parted);
CREATE TABLE child () INHERITS (parent);
DROP TABLE child;
ALTER TABLE parent ADD CONSTRAINT check_a CHECK (a > 0);
ALTER TABLE list_parted ATTACH PARTITION parent FOR VALUES IN (1);
INSERT INTO parent VALUES (1);
UPDATE parent SET a = 2 WHERE a = 1;
SELECT relhassubclass FROM pg_class WHERE relname='parent';
