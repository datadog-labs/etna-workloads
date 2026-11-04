CREATE TABLE test(a BIGINT) AS VALUES (1);
SELECT "test.a" FROM (SELECT a AS "test.a" FROM test);
