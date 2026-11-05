CREATE TABLE t(tid int, balance int);
CREATE TABLE s(sid int, delta int);
MERGE INTO t USING s ON t.tid = s.sid
WHEN MATCHED THEN DELETE
WHEN MATCHED THEN UPDATE SET balance = t.balance - s.delta;
