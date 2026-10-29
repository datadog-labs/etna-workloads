CREATE TABLE t2d('a' integer, b, PRIMARY KEY('a'));
SELECT name FROM sqlite_master WHERE tbl_name='t2d' ORDER BY name;
