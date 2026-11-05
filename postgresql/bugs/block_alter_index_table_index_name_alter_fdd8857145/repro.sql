CREATE TABLE t (id int4);
CREATE INDEX t_idx ON t (id);
ALTER INDEX t_idx ALTER COLUMN id SET (n_distinct=100);
DROP INDEX t_idx;
