create table t (f1 int, f2 int[]);
insert into t (f2[1], f2[2]) values (3,4), (5,6);
select * from t;
