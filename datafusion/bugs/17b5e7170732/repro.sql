create table t as values({r: 'a', c: 1}), ({r: 'b', c: 2.3});
select * from t;
select arrow_typeof(column1) from t;
