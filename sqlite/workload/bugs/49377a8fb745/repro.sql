CREATE VIRTUAL TABLE e1 USING fts5(text, tokenize = 'porter unicode61');
INSERT INTO e1 VALUES ('just a few words with a / inside');
SELECT rowid, format('%g',bm25(e1)) FROM e1 WHERE e1 MATCH '"/" OR "just"' ORDER BY rank;
