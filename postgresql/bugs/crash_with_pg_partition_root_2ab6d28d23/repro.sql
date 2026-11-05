CREATE TABLE p (a int) PARTITION BY RANGE (a);
CREATE TABLE p1 PARTITION OF p FOR VALUES FROM (0) TO (10);
SELECT pg_partition_root('p');
SELECT pg_partition_root('p1');
