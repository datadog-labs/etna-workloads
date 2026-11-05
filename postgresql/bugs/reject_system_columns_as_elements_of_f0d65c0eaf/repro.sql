CREATE TABLE pk (a int PRIMARY KEY);
CREATE TABLE fk1 (x int, FOREIGN KEY (tableoid) REFERENCES pk(a));
CREATE TABLE fk2 (x oid, FOREIGN KEY (x) REFERENCES pk(tableoid));
