explain (verbose, costs off)
select r is null as isnull, r is not null as isnotnull
from (values (1,row(1,2)), (null,null)) r(a,b);
