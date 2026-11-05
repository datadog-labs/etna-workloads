select f1, (with cte1(x,y) as (select 1,2)
            select count((select i4.f1 from cte1))) as ss
from (values (0),(1)) i4(f1);
