PRAGMA verify_parallelism;
SET threads=4;
CREATE TABLE t AS SELECT range i FROM range(2049);
SELECT count(*)=2049 AND min(rn)=1 AND max(rn)=2049 AND count(DISTINCT rn)=2049 FROM (SELECT row_number() OVER () rn FROM t);
