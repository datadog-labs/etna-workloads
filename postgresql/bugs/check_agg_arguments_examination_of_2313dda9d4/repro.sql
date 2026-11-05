create temp table t(b1 bool, x int);
insert into t values (true,1),(false,2);
select (select max(x) filter (where b1)) from t;
select (select max(x) filter (where b1) from (values(1)) v) from t;
select (select max(x) filter (where sum(x) > 0) from (values(1)) v) from t;
select (select max(x) filter (where bool_or(x > 0)) from (values(1)) v) from t;
