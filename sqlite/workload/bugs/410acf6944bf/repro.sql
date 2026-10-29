CREATE VIRTUAL TABLE fts USING fts5(content);
INSERT INTO fts(fts, rank) VALUES ('secure-delete', 1);
INSERT INTO fts(rowid, content) VALUES
  (3407, 'profile profile profile profile profile profile profile profile pull pulling pulling really');
DELETE FROM fts WHERE rowid IS 3407;
INSERT INTO fts(fts) VALUES ('integrity-check');
SELECT 'done';
