SET datafusion.execution.target_partitions = 4;
CREATE TABLE left_table(a INT, b INT, c INT);
CREATE TABLE right_table(x INT, y INT, z INT);
EXPLAIN SELECT * FROM left_table JOIN right_table ON left_table.a<right_table.x ORDER BY x;
EXPLAIN SELECT * FROM left_table JOIN right_table ON left_table.a<right_table.x AND left_table.b=right_table.y ORDER BY x;
