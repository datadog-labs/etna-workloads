COPY (SELECT 1 AS c1, 2 AS c2) TO 'abc.csv' STORED AS CSV OPTIONS ('format.has_header' 'true');
CREATE EXTERNAL TABLE abc_ordered STORED AS CSV WITH ORDER (c1, c2 DESC) LOCATION 'abc.csv' OPTIONS ('format.has_header' 'true');
SHOW CREATE TABLE abc_ordered;
