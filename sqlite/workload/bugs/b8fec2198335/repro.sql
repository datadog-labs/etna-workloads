CREATE TABLE tab (
  prim TEXT PRIMARY KEY,
  a INTEGER,
  comp INTEGER AS (a),
  b INTEGER,
  x INTEGER
);
INSERT INTO tab (prim, a, b) VALUES ('k', 0, 0);
INSERT INTO tab (prim, b) VALUES ('k', 5)
  ON CONFLICT(prim) DO UPDATE SET b=excluded.b;
SELECT * FROM tab;
