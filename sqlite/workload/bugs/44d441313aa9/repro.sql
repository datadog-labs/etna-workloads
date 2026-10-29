.dbconfig dqs_ddl on
.dbconfig dqs_dml on
CREATE TABLE t1(a,b);
CREATE INDEX x1 on t1("b");
ALTER TABLE t1 DROP COLUMN b;
