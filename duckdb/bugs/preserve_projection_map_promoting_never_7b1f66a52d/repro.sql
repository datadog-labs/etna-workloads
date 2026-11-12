.mode list
.nullvalue NULL
CREATE TABLE p AS SELECT i + 1000 AS r, i AS s, i AS q FROM range(5) t(i);
CREATE TABLE x AS SELECT i AS w FROM range(5) t(i);
CREATE TABLE y AS SELECT i + 100 AS w2 FROM range(5) t(i);
CREATE TABLE y2 AS SELECT i AS w2 FROM range(5) t(i);
SELECT count(DISTINCT p.q) FROM p ANTI JOIN x ON p.r = x.w JOIN y ON p.s = y.w2;
