with
  cte1(x, y) AS ( select 1, 2, 3 ),
  cte2(z) as ( select 1 from cte1 )
select * from cte2, cte1;
