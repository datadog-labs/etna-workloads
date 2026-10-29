PRAGMA foreign_keys=ON;
CREATE TABLE main(id INTEGER PRIMARY KEY);
CREATE TABLE sub(id INT REFERENCES main(id));
INSERT INTO main VALUES(1);
.import '|printf "3\n1\n"' sub
SELECT * FROM sub;
