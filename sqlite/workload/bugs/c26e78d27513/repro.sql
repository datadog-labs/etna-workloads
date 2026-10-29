CREATE VIRTUAL TABLE vt1 USING fts5(c1, c2, prefix = 1, tokenize = "ascii");
INSERT INTO vt1 VALUES (x'e4', '䔬');
INSERT INTO vt1(vt1) VALUES('integrity-check');
SELECT 'done';
