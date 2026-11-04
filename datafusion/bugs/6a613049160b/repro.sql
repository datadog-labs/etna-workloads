COPY (SELECT 1 AS c1, 2 AS c2, 3 AS c3 WHERE false) TO 'empty.csv' STORED AS CSV OPTIONS ('format.has_header' 'true');
CREATE EXTERNAL TABLE t STORED AS CSV LOCATION 'empty.csv' OPTIONS ('format.has_header' 'true');
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 't' ORDER BY ordinal_position;
