SET datafusion.execution.target_partitions = 4;
SET datafusion.optimizer.enable_topk_aggregation = true;
create table nullable_vals (v varchar) as values (NULL), (''), ('a'), ('b');
select distinct v from nullable_vals order by v asc nulls first limit 1;
select distinct v from nullable_vals order by v asc nulls first limit 3;
select distinct v from nullable_vals order by v asc nulls last limit 4;
select distinct v from nullable_vals order by v desc nulls first limit 1;
