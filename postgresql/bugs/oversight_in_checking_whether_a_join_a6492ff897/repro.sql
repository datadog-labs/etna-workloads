create table t1(ten int);
create table t2(ten int);
insert into t1 select g%10 from generate_series(1,20) g;
insert into t2 select g%10 from generate_series(1,20) g;
select count(*) from t1, lateral (select * from t2 where t2.ten in (values (t1.ten), (1))) s;
