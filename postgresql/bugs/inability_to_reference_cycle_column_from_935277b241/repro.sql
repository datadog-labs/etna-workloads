with recursive test as (
  select 0 as x
  union all
  select (x + 1) % 10 from test where not is_cycle
) cycle x set is_cycle using path
select * from test;
