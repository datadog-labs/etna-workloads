SELECT median(v) AS m, arrow_typeof(median(v)) AS t FROM (VALUES (arrow_cast(-128, 'Int8')), (arrow_cast(127, 'Int8'))) AS t(v);
CREATE TABLE t(c int) AS VALUES (1),(2),(3),(4),(5),(6);
SELECT median(c), arrow_typeof(median(c)) FROM t;
