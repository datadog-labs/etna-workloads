select (x+y)*1, sum(z)
 from (select 1 as x, 2 as y, 3 as z) s
 group by grouping sets (x+y, x);
select four, x || 'x'
  from (select four, 'foo'::text as x from generate_series(0,3) four) as t
  group by grouping sets (four, x)
  order by four;
