CREATE TABLE p2 (a int, b text) PARTITION BY RANGE ((a+1), substr(b, 1, 5));
CREATE TABLE p2_1 PARTITION OF p2 FOR VALUES FROM (-1, 'aaaaa') TO (100, 'ccccc');
\d+ p2_1
