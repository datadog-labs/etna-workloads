.dbconfig defensive off
CREATE TABLE t7(x);
PRAGMA writable_schema=ON;
UPDATE sqlite_master SET sql='CREATE TABLE [M%s%s%s%s%s%s%s%s%s%s%s%s%s';
VACUUM;
