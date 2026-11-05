CREATE UNLOGGED TABLE t (a int NOT NULL, b text);
ALTER TABLE t ADD COLUMN c int GENERATED ALWAYS AS IDENTITY;
SELECT relname, relpersistence FROM pg_class WHERE relname LIKE 't\_%' ORDER BY 1;
