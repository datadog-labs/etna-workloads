select r, r is null as isnull, r is not null as isnotnull
from (values (1,row(1,2)), (1,row(null,null)), (null,row(null,null)), (null,null) ) r(a,b);
