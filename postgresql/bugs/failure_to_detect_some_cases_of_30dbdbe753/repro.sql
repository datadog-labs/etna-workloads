create temp table t(a int);
select avg((select avg(a1.a order by (select avg(a2.a) from t a3)) from t a1(a))) from t a2(a);
