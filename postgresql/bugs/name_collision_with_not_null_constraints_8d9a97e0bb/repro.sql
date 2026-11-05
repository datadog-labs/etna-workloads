CREATE TABLE t (col integer NOT NULL, CONSTRAINT t_col_not_null CHECK (col IS NOT NULL));
SELECT conname, contype FROM pg_constraint WHERE conrelid='t'::regclass ORDER BY 1;
