CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT, value TEXT);
CREATE VIRTUAL TABLE test_idx USING fts5(name, content=test, content_rowid=id);
INSERT INTO test_idx (test_idx, rowid, name) VALUES('delete', 1, 'quick');
