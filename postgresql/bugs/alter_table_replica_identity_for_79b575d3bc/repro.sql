CREATE TABLE t (id int4range, valid_at daterange, PRIMARY KEY (id, valid_at WITHOUT OVERLAPS));
ALTER TABLE t REPLICA IDENTITY USING INDEX t_pkey;
\d t
