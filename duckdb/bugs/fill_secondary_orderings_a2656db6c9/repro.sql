with source as (
	select i, (i + 1) * 3 % 5 as permuted,
		if(permuted = 4, NULL, permuted) as missing
	from (from range(5) tbl(i) union all select NULL::INTEGER) t(i)
)
select i, permuted,
	fill(missing order by permuted asc nulls last) over (order by i) as filled
from source
qualify filled is distinct from permuted;
