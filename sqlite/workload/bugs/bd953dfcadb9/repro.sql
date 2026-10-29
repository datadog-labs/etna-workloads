WITH t1(x) AS (VALUES(9e+999)) SELECT sum(x), avg(x), total(x) FROM t1;
WITH t1(x) AS (VALUES(-9e+999)) SELECT sum(x), avg(x), total(x) FROM t1;
