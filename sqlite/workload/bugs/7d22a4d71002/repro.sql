CREATE TABLE p(a INTEGER PRIMARY KEY, b, c, UNIQUE(b,c));
INSERT INTO p VALUES(1,'x','y');
CREATE TABLE c(x, y, FOREIGN KEY(x,y) REFERENCES p(c,b));
INSERT INTO c VALUES('y','x');
PRAGMA foreign_key_check(c);
INSERT INTO c VALUES('x','y');
PRAGMA foreign_key_check(c);
