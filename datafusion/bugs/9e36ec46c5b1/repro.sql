CREATE TABLE t1 AS VALUES (1, 3), (2, 2);
SELECT * FROM t1 u, unnest(generate_series(1, u.column2));
