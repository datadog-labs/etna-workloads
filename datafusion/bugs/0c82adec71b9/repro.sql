create table t1 as select {a: 1, b: 'x'} as s;
create table t2 as select {b: 'y', a: 2} as s;
select arrow_typeof(s) from (select * from t1 union all select * from t2) limit 1;
select t1.s = t2.s as eq from t1, t2;
