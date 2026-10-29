PRAGMA foreign_keys=OFF;
CREATE TABLE t1(a,b,c AS(1),d, FOREIGN KEY(c,d,b,a,b,d,b,c) REFERENCES t0);
PRAGMA foreign_key_check;
