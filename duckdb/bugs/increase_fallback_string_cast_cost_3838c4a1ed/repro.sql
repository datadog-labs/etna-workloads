.mode list
.nullvalue NULL
create table t1 as select * from values ('1-2', '3-4', 'a-z', NULL) as r(v);
SELECT list_extract(string_split(v, '-'), 1) FROM t1;
SET old_implicit_casting = true;
SELECT list_extract(string_split(v, '-'), 1) FROM t1;
