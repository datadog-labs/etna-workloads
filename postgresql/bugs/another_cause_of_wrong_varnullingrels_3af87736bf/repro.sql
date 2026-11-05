create table a as select g f from generate_series(1,1000) g;
create table b as select g f from generate_series(1,1000) g;
create table c as select g f from generate_series(1,1000) g;
create table d as select g f from generate_series(1,10000) g;
analyze;
explain (costs off)
select * from a t1
  left join ((select t2.f from b t2
                left join c t3 on t2.f > 0
                where t2.f <> coalesce(t3.f, -1)) s
             left join d t4 on s.f > 1)
    on s.f = t1.f;
