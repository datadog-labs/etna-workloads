CREATE TABLE t (d text COLLATE "C");
CREATE VIEW v AS SELECT d FROM t;
CREATE OR REPLACE VIEW v AS SELECT d COLLATE "POSIX" AS d FROM t;
SELECT attcollation = 'C'::regcollation AS still_c FROM pg_attribute WHERE attrelid='v'::regclass AND attname='d';
