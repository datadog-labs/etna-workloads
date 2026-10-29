CREATE TABLE e1(a, b, c, d, e);
CREATE INDEX e1cde ON e1(c, d, e);
EXPLAIN QUERY PLAN SELECT * FROM e1 WHERE c = ? AND (d, e) > (?, ?);
EXPLAIN QUERY PLAN SELECT * FROM e1 WHERE (d, e) BETWEEN (?, ?) AND (?, ?) AND c = ?;
