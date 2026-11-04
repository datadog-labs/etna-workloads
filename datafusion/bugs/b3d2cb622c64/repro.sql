with t as (select 'foo' as x)
select x, count(*) as "Count"
from t
group by x
order by 2 desc;
