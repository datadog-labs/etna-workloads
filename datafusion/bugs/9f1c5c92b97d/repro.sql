CREATE TABLE dup_src AS VALUES(1, 2);

CREATE TABLE dup_ctas_with_schema(left_c1 bigint, right_c1 bigint) AS
SELECT dup_src.column1, right_src.column1
FROM dup_src
CROSS JOIN (SELECT column2 AS column1 FROM dup_src) right_src;

SELECT left_c1, right_c1 FROM dup_ctas_with_schema;
