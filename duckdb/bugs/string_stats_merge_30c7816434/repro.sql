.mode list
.nullvalue NULL
CREATE TABLE t AS SELECT 'abcdefghijklzzzz' AS s, true AS c;
SELECT (CASE WHEN c THEN s ELSE 'abcdefghijklA' END) > 'abcdefghijklB' FROM t;
