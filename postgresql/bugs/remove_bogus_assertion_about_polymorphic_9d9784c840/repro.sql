create function polyf(x anyarray) returns anyarray as $$
  select x
$$ language sql;
select polyf(stavalues1) from pg_statistic;
