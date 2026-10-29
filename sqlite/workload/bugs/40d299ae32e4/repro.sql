PRAGMA encoding = 'UTF-16le';
CREATE VIRTUAL TABLE vt0 USING fts5(c0);
.parameter set @v x'2a12'
INSERT INTO vt0 VALUES (@v);
SELECT quote(c0) FROM vt0;
INSERT INTO vt0(vt0) VALUES('integrity-check');
