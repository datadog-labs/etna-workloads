CREATE VIRTUAL TABLE x1 USING fts5(a, b);
INSERT INTO x1 VALUES('xyz', '1 2 3 4 5 6 7 8 9 10 11 12 13');
SELECT snippet(x1, 1, '[', ']', '...', 5) FROM x1('xyz');
