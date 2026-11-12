CREATE TABLE bt AS SELECT (range >= 122880) AS b FROM range(245760);
.once "|grep Groups"
EXPLAIN ANALYZE SELECT sum(rowid) FROM bt WHERE b = true;
