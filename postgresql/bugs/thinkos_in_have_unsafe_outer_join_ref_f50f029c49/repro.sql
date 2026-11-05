create temp table i4 as select 1 as f1;
create temp table i8 as select 1::int8 as q1;
explain (verbose, costs off)
select 1 from
  i4
  inner join
    ((select 42 as n from i4 x1 left join i8 x2 on f1 = q1) as ss1
     right join (select 1 as z) as ss2 on true)
  on false,
  lateral (select i4.f1, ss1.n from i8 as i8 limit 1) as ss3;
