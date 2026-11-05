create table update_test(a int, b int);
UPDATE update_test SET a = v.* FROM (VALUES(100, 20)) AS v(i, j) WHERE update_test.b = v.j;
