.mode list
.nullvalue NULL
CREATE TABLE integers(i INTEGER);
INSERT INTO integers VALUES (0), (1), (1), (NULL);
SELECT ref_0.i,
       (SELECT 1 WHERE EXISTS (SELECT 1 WHERE NULL::INTEGER | ref_0.i)) AS result
FROM integers ref_0
ORDER BY ref_0.i NULLS LAST;
