CREATE TABLE t(s VARCHAR) AS VALUES ('foo'), ('Bazzz'), ('Barrr');
SELECT * FROM t WHERE s ~* '^bazzz$' ORDER BY s;
SELECT * FROM t WHERE s !~* '^bazzz$' ORDER BY s;
SELECT * FROM t WHERE s ~* '^(foo|bazzz)$' ORDER BY s;
SELECT * FROM t WHERE s !~* '^(foo|bazzz)$' ORDER BY s;
