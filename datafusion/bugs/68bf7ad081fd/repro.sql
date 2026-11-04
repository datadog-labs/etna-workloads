CREATE TABLE foo AS VALUES (1, 2), (3, 4), (5, 6);
SELECT column1 FROM foo ORDER BY column2 % 2, column2;
