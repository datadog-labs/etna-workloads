CREATE VIRTUAL TABLE f USING FTS5(filename, tokenize="trigram");
INSERT INTO f (rowid, filename) VALUES (10,'giraffe.png'),(20,'жираф.png'),(30,'cat.png'),(40,'кот.png');
SELECT rowid FROM f WHERE filename GLOB '*ир*';
