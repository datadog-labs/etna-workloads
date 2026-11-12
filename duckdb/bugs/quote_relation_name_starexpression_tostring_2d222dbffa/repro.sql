CREATE VIEW v AS SELECT 1 AS a;
CREATE TABLE "weird name"(a INT);
CREATE VIEW w AS SELECT "weird name".* FROM "weird name";
SELECT sql FROM duckdb_views() WHERE view_name='w';
