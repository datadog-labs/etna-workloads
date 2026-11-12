CREATE SCHEMA s;
CREATE MACRO s.coalesce(a, b) AS 999;
SELECT s.coalesce(NULL, 5);
