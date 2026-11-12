.mode list
.nullvalue NULL
CREATE TABLE flat(s STRUCT(a INT, b INT), i INT, j INT);
INSERT INTO flat VALUES ({'a': 2, 'b': 3}, 1, 7), ({'a': 0, 'b': 4}, 2, 8);
SELECT i, s.b FROM flat WHERE s.a AND i > 0 ORDER BY i;
SELECT i, j, s.b FROM flat WHERE s.a AND i > 0 AND j > 0 ORDER BY i;
SELECT i FROM flat WHERE s.a::BOOLEAN AND i > 0 AND j > 0 ORDER BY i;
CREATE TABLE nested(s STRUCT(a INT, b STRUCT(c INT, d INT)), i INT, j INT);
INSERT INTO nested VALUES ({'a': 2, 'b': {'c': 5, 'd': 6}}, 1, 7), ({'a': 0, 'b': {'c': 0, 'd': 10}}, 2, 8);
SELECT i, s.b.d FROM nested WHERE s.b.c AND i > 0 AND j > 0 ORDER BY i;
CREATE TABLE t1(c0 VARCHAR, c1 INT, c2 STRUCT(k0 BOOLEAN, k1 VARCHAR, k2 VARCHAR, k3 INT, k4 BOOLEAN), PRIMARY KEY(c1, c0));
INSERT INTO t1(c0, c1, c2) VALUES ('*', -1537721958, {'k0': false, 'k1': 'O', 'k2': 'w', 'k3': -1093516081, 'k4': false});
SELECT t1.c1 FROM t1 INNER JOIN (SELECT (t1.c0 || t1.c0) AS col0 FROM t1 WHERE t1.c2['k3']) AS sub0 ON t1.c2['k3'] WHERE (t1.c1 > t1.c1);
SELECT t1.c1, sub0.col0 FROM t1 INNER JOIN (SELECT (t1.c0 || t1.c0) AS col0 FROM t1 WHERE t1.c2['k3']) AS sub0 ON t1.c2['k3'];
SELECT i, s.b FROM flat WHERE s.a AND i < j ORDER BY i;
SELECT i, j, s.b FROM flat WHERE s.a AND i < j AND i + j > 2 ORDER BY i;
SELECT i, s.b.d FROM nested WHERE s.b.c AND i < j ORDER BY i;
