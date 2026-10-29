CREATE VIRTUAL TABLE xyz USING fts5(name, content='');
INSERT INTO xyz(xyz, rank) VALUES('secure-delete', 1);
INSERT INTO xyz(rowid, name) VALUES(1, 'A');
INSERT INTO xyz(rowid, name) VALUES(2, 'A');
INSERT INTO xyz(xyz, rowid, name) VALUES('delete', 2, 'A');
pragma quick_check;
