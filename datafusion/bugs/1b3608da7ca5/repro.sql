SELECT arrow_typeof(column1), column1 FROM (VALUES (NULL,'a'),(NULL,'b')) ORDER BY column2;
SELECT arrow_typeof(column1), arrow_typeof(column2) FROM VALUES (NULL, 1.2);
SELECT arrow_typeof(COALESCE(column1, column2)) FROM VALUES (null, 1.2);
