with cte(c) as materialized (select row(1, 2)),
     cte2(c) as (select * from cte)
select * from cte2 as t
where (select * from (select c as c1) s
       where (select (c1).f1 > 0)) is not null;
create view composite_v as
with cte(c) as materialized (select row(1, 2)),
     cte2(c) as (select * from cte)
select 1 as one from cte2 as t
where (select * from (select c as c1) s
       where (select (c1).f1 > 0)) is not null;
select pg_get_viewdef('composite_v', true);
