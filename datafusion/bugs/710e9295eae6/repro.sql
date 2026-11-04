with recursive t(k, v) as (
  select 1 k, 10 v
  union all
  select 2, 20 from t where k = 1
)
select v from t order by 1;

with recursive t(k, v) as (
  select 1 k, 10 v
  union all
  select 2, 20 from t where v = 10
)
select v from t order by 1;

with recursive t(k, v) as (
  select 1 k, 10 v
  union
  select 2, 10 from t where v = 10
)
select v from t order by 1;
