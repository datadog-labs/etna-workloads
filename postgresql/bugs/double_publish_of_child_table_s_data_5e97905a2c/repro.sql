CREATE TABLE p (a int) PARTITION BY RANGE (a);
CREATE TABLE p1 PARTITION OF p FOR VALUES FROM (0) TO (10);
CREATE PUBLICATION pub FOR TABLE p, p1 WITH (publish_via_partition_root=1);
SELECT * FROM pg_publication_tables;
