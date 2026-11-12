.mode list
.nullvalue NULL
CREATE TABLE t AS SELECT union_value(a := 'q' || i::VARCHAR)::UNION(a VARCHAR, b VARCHAR) u FROM range(3000) t(i);
SELECT count(*) FROM (SELECT try_cast(u AS UNION(a INT, b VARCHAR, c VARCHAR)) x FROM t) WHERE x IS NULL;
