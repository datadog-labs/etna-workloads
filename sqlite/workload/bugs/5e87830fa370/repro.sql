CREATE TABLE k1(x REFERENCES s1);
PRAGMA foreign_key_check(k1);
INSERT INTO k1 VALUES(1);
PRAGMA foreign_key_check(k1);
