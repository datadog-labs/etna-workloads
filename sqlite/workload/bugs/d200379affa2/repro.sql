CREATE TABLE t1(
    a INT,
    b INT,
    -- comment with, comma
    c INT
);
ALTER TABLE t1 DROP COLUMN c;
SELECT sql FROM sqlite_schema;
