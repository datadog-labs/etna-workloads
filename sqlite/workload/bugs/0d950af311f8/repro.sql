CREATE TABLE t0 (c0);
INSERT INTO t0(c0) VALUES ('a');
SELECT * FROM t0 WHERE LIKELY(t0.rowid) <= '0';
SELECT * FROM t0 WHERE unlikely(t0.rowid) <= '0';
SELECT * FROM t0 WHERE likelihood(t0.rowid, 0.5) <= '0';
