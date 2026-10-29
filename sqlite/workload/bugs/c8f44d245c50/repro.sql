CREATE VIRTUAL TABLE p1 USING fts5(a);
INSERT INTO p1 VALUES('x a a a a a a a');
SELECT snippet(p1, 0, '[', ']', NULL, 6) FROM p1('x');
SELECT snippet(p1, 0, NULL, ']', '...', 6) FROM p1('x');
SELECT snippet(p1, 0, '[', NULL, '...', 6) FROM p1('x');
