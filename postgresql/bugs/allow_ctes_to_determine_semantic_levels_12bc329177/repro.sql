select f1, (with cte1(x,y) as (select 1,2)
            select count((select i4.f1 from cte1))) as ss
from (values (1)) i4(f1);
with a as ( select id from (values (1), (2)) as v(id) ),
     b as ( select max((select sum(id) from a)) as agg )
select agg from b;
