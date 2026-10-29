SELECT ('abc', 1) = (SELECT 'ABC' COLLATE nocase, 1);
CREATE TABLE t33(a, b, c);
INSERT INTO t33 VALUES ('abc', 1, 'i');
INSERT INTO t33 VALUES ('ABC', 1, 'ii');
SELECT (a, b) = (SELECT 'abc' COLLATE nocase, 1) FROM t33;
