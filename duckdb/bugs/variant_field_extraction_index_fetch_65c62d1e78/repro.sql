.mode list
.nullvalue NULL
CREATE TABLE tbl(i INT PRIMARY KEY, v VARIANT);
INSERT INTO tbl select i, {'a': i, 'b': i % 5} from range(100) t(i);
SELECT v FROM tbl WHERE i=42;
SELECT v['a']::INTEGER FROM tbl WHERE i=42;
