create temp table t(a int, x text, y text);
insert into t values (1,'hij','b'),(2,'HIJ','a');
SELECT array_agg(x COLLATE "C" ORDER BY y COLLATE "POSIX") FROM t;
SELECT array_agg(a ORDER BY x COLLATE "C", y COLLATE "POSIX") FROM t;
