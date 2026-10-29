CREATE TABLE a(x);
INSERT INTO a VALUES(1),(2);
CREATE TABLE b(y);
INSERT INTO b VALUES(3);
CREATE TABLE c(z);
.progress 5 --limit 21 --once -q
.dump
