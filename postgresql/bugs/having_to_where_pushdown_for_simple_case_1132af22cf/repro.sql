CREATE COLLATION case_sensitive (provider = icu, locale = 'und', deterministic = true);
CREATE COLLATION case_insensitive (provider = icu, locale = 'und-u-ks-level2', deterministic = false);
CREATE TABLE test3ci (x text COLLATE case_insensitive);
INSERT INTO test3ci VALUES ('abc'), ('ABC');
SELECT x, count(*) FROM test3ci GROUP BY x HAVING (CASE x WHEN 'abc' COLLATE case_sensitive THEN true ELSE false END);
