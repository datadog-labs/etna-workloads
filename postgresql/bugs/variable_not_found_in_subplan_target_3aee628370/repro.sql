begin;
create temp table t (a int unique, b int);
insert into t values (1, 2);
select t1.a from t t1
  left join t t2 on t1.a = t2.a
       join t t3 on true
where exists (select 1 from t t4
                join t t5 on t4.b = t5.b
                join t t6 on t5.b = t6.b
              where t1.a = t4.a and t3.a = t5.a and t4.a = 1);
rollback;
