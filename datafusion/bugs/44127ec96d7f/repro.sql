create table t1(v1 int);
insert into t1 values (1);
SELECT LEAD(NULL, 0, false) OVER () FROM t1;
SELECT LAG(NULL, 0, false) OVER () FROM t1;
SELECT LEAD(NULL, 1, false) OVER () FROM t1;
SELECT LAG(NULL, 1, false) OVER () FROM t1;
insert into t1 values (2);
SELECT LEAD(NULL, 1, false) OVER () FROM t1;
SELECT LAG(NULL, 1, false) OVER () FROM t1;
