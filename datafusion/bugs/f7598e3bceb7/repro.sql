create table t ("A" int, "B.C" int);
insert into t values (1, 2);
select * from (select * from t) t_(x, y);
explain select * from (select * from t) t_(x, y);
