CREATE TABLE t5(x);
.auth ON --deny "ALTER_TABLE*"
ALTER TABLE t5 ADD COLUMN c2;
.auth OFF
SELECT sql FROM sqlite_master;
