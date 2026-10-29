create table t(a,b,c);
insert into t values('1','1','a'),('1','2','b'),('1','3','c'),('1','1','d'),('1','2','e'),('1','3','f');
select a from (select distinct a, b from t);
