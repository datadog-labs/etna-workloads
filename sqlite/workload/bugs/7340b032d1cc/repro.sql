CREATE VIRTUAL TABLE p1 USING fts5(a, b);
INSERT INTO p1 VALUES('x a a a a a a a a a a','a a a a a a a a a a a a a a a a a a a x');
SELECT snippet(p1, 0, '[', NULL, '...', -2147483648) FROM p1('x');
SELECT snippet(p1, 0, '[', NULL, '...', -2147483649) FROM p1('x');
SELECT snippet(p1, 0, '[', NULL, '...', 2147483648) FROM p1('x');
SELECT snippet(p1, 0, '[', NULL, '...', 2147483649) FROM p1('x');
