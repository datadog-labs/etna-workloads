.mode list
.nullvalue NULL
SET debug_verify_serializer = true;
CREATE TABLE tbl(g INTEGER, s VARCHAR);
INSERT INTO tbl VALUES (1, 'a'), (1, 'A'), (1, 'Z'), (2, 'b'), (2, 'B');
SELECT count(DISTINCT s COLLATE NOCASE) FROM tbl;
SELECT count(DISTINCT s) FROM tbl;
SELECT len(list(DISTINCT s COLLATE NOCASE)), len(list(DISTINCT s)),
       len(list(DISTINCT s COLLATE NOCASE))
FROM tbl;
SELECT count(DISTINCT row(s)), len(list(DISTINCT row(s COLLATE NOCASE)))
FROM tbl;
