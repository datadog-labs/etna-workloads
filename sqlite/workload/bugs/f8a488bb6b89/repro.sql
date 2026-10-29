CREATE VIRTUAL TABLE v1 USING fts5vocab(nosuchtable, col);
CREATE VIRTUAL TABLE nosuchtable USING fts3(a, b);
INSERT INTO nosuchtable VALUES('id', '*id');
SELECT * FROM v1 WHERE term=='nosuchterm';
