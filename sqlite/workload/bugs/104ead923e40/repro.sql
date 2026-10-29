CREATE TABLE x1(a);
INSERT INTO x1 VALUES(1);
SELECT * FROM x1 CROSS JOIN generate_series(1,2) t1, generate_series(1,2) t2, generate_series(1,2) t3
  WHERE t1.value = t2.value AND t1.value = t3.value;
