explain (verbose, costs off)
with recursive test as (
  select 1 as x
  union all
  select x + 1
  from test
) search breadth first by x set y
select * from test limit 5;
