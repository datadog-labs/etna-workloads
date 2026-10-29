PRAGMA page_size=1024;
PRAGMA encoding='UTF-16le';
CREATE TABLE t14(n, c);
INSERT INTO t14 VALUES
   (1000, CAST(printf('%.*c', 1000, 'a') AS BLOB)),
   (5000, CAST(printf('%.*c', 5000, 'a') AS BLOB));
SELECT n, length(c), length(CAST(c AS TEXT)) FROM t14 ORDER BY +n;
