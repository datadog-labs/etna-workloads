CREATE TABLE t8a(a,b);
CREATE TABLE t8b(x,y);
CREATE INDEX i8c ON t8b(y) WHERE x = 'value';
EXPLAIN QUERY PLAN SELECT * FROM t8a LEFT JOIN t8b ON (x = 'value' AND y = a);
