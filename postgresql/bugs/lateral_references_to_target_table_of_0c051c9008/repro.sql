create temp table t4 as select g as f1 from generate_series(1,3) g;
create temp table xx1 as select f1 as x1, -f1 as x2 from t4;
update xx1 set x2 = f1 from (select * from t4 where f1 = x1) ss;
update xx1 set x2 = f1 from (select * from t4 where f1 = xx1.x1) ss;
delete from xx1 using (select * from t4 where f1 = x1) ss;
select count(*) from xx1;
