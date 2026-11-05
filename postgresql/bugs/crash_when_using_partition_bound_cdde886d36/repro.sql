CREATE TABLE range_parted (a date) PARTITION BY RANGE (a);
CREATE TABLE p PARTITION OF range_parted FOR VALUES FROM (somename.somename) TO ('2019-01-01');
SELECT 1;
