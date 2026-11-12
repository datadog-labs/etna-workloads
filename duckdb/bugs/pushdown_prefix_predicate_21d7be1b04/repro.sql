CREATE TABLE t AS SELECT lpad(i::VARCHAR,8,'0') s FROM range(600000) r(i);
EXPLAIN SELECT count(*) FROM t WHERE starts_with(s, '00024999');
