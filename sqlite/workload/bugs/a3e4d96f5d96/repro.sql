create table t1(a);
.auth ON
SELECT name FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM temp.sqlite_master) WHERE type='table';
