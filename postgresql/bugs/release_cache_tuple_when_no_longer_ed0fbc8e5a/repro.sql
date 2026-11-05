CREATE TABLE pt (a int PRIMARY KEY, b int) PARTITION BY RANGE (a);
CREATE TABLE pt1 PARTITION OF pt FOR VALUES FROM (0) TO (100);
CREATE PUBLICATION p FOR TABLE pt WHERE (a > 1) WITH (publish_via_partition_root=true);
ALTER PUBLICATION p SET (publish_via_partition_root=0);
ALTER PUBLICATION p SET TABLE pt;
ALTER PUBLICATION p SET (publish_via_partition_root=0);
