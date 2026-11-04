create table t1(a int, b varchar, c double, d int);
create table t2(a int, b varchar, c double, d int);
update t1 set b = t2.b, d = 1 from t2 where t1.a = t2.a;
create table t3(a int, b varchar, c double, d int);
explain update t1 set b = t2.b, c = t3.a, d = 1 from t2, t3 where t1.a = t2.a and t1.a = t3.a;
