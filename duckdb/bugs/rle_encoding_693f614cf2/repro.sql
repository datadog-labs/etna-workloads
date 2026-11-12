SET force_compression='rle';
CREATE TABLE t(x DOUBLE);
INSERT INTO t VALUES (0e0),('-0'::DOUBLE),(1e0);
CHECKPOINT;
SELECT signbit(x) FROM t WHERE x = 0 ORDER BY 1;
