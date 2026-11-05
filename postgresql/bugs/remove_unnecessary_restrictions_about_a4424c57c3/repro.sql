create temp table t(a int, b int);
insert into t values (1,2);
select row(1,2) in (select a,b from t) as x;
select (select t from t) in (row(1,2)::t, row(3,4)::t) as y;
select t in (row(1,2), row(3,4)) as z from t;
select row(1,2) in (t) as w from t;
