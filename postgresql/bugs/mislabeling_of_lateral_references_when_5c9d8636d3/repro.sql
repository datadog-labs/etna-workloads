create table t1 as select g%10 as ten, g as unique1 from generate_series(1,100) g;
create table t2 as select g%10 as ten, g as fivethous from generate_series(1,100) g;
select t1.ten, sum(x) from
  t1 left join lateral (
    select t1.ten + t2.ten as x, t2.fivethous from t2
  ) ss on t1.unique1 = ss.fivethous
group by t1.ten
order by t1.ten;
