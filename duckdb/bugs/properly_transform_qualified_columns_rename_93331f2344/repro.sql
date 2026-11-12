.mode list
.nullvalue NULL
CREATE TABLE integers(i INTEGER, j INTEGER, k INTEGER);
INSERT INTO integers VALUES (1, 2, 3);
SELECT renamed_col FROM (SELECT * RENAME i AS renamed_col FROM integers);
SELECT renamed_col FROM (SELECT COLUMNS(* RENAME i AS renamed_col) FROM integers);
SELECT renamed_col FROM (SELECT * RENAME integers.i AS renamed_col FROM integers);
SELECT renamed_col FROM (SELECT integers.* RENAME integers.i AS renamed_col FROM integers);
SELECT d, c FROM (SELECT * RENAME ("a.b" AS d) FROM (SELECT 1 AS "a.b", 2 AS c));
