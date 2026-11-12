.mode list
.nullvalue NULL
CREATE TABLE test(s STRUCT(a INTEGER, b INTEGER));
INSERT INTO test VALUES ({'a': NULL, 'b': 1});
ALTER TABLE test ALTER s.a SET NOT NULL;
