.mode list
.nullvalue NULL
CREATE TABLE outer_values(i INTEGER);
INSERT INTO outer_values VALUES (1), (2);
CREATE TABLE inner_values(i INTEGER);
INSERT INTO inner_values VALUES (1);
SELECT outer_values.i,
       EXISTS (SELECT 1 FROM inner_values WHERE inner_values.i = outer_values.i HAVING true),
       (SELECT 1 FROM inner_values WHERE inner_values.i = outer_values.i HAVING true),
       EXISTS (SELECT 1 FROM inner_values WHERE inner_values.i = outer_values.i HAVING false),
       (SELECT 1 FROM inner_values WHERE inner_values.i = outer_values.i HAVING false)
FROM outer_values
ORDER BY outer_values.i;
