create temp table t(f1 int);
insert into t values (1),(2);
select count(*) from t t1,
  lateral (select * from t t2 inner join t t3 on t1.f1 = 1
           inner join (t t4 left join t t5 on true) on true) ss;
