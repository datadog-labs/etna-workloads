CREATE TABLE p (id bigint NOT NULL PRIMARY KEY, a bigint, FOREIGN KEY (a) REFERENCES p(id)) PARTITION BY RANGE (id);
CREATE TABLE p1 (id bigint NOT NULL PRIMARY KEY, a bigint);
ALTER TABLE p ATTACH PARTITION p1 FOR VALUES FROM (0) TO (10);
SELECT conname, contype FROM pg_constraint WHERE conrelid='p1'::regclass ORDER BY 1;
