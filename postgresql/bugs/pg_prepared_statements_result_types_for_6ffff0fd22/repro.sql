PREPARE q8 AS SELECT 1;
PREPARE q9(int) AS DELETE FROM pg_class WHERE false AND oid = $1;
SELECT name, result_types FROM pg_prepared_statements ORDER BY name;
