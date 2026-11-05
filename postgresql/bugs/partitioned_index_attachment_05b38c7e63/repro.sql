CREATE TABLE pkpart (a int) PARTITION BY LIST (a);
CREATE TABLE pkpart1 PARTITION OF pkpart FOR VALUES IN (1);
ALTER TABLE pkpart1 ADD PRIMARY KEY (a);
ALTER TABLE pkpart ADD PRIMARY KEY (a);
SELECT relname, relispartition FROM pg_class WHERE relname LIKE 'pkpart%pkey' ORDER BY 1;
CREATE TABLE fk (a int REFERENCES pkpart);
