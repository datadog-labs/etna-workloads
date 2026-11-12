.mode list
.nullvalue NULL
CREATE TABLE wide_join_description AS FROM query(
	'SELECT ' || array_to_string(['NULL::BIGINT AS c' || i FOR i IN range(2050)], ', '));
SET disabled_optimizers='';
SELECT count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l FULL JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON false;
SELECT count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l FULL JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON NULL;
SELECT count(*) FROM (DESCRIBE SELECT * FROM wide_join_description) l FULL JOIN (DESCRIBE SELECT * FROM wide_join_description) r ON false;
SELECT count(l.column_name),count(r.column_name),count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l FULL JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON false;
SELECT count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l FULL JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON true;
SELECT count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l LEFT JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON false;
SELECT count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l RIGHT JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON false;
SET disabled_optimizers='unused_columns';
SELECT count(*) FROM (DESCRIBE SELECT 1 AS a, 2 AS b) l FULL JOIN (DESCRIBE SELECT 1 AS c, 2 AS d, 3 AS e) r ON false;
