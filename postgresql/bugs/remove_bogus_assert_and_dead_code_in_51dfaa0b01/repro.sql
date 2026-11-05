explain (verbose, costs off)
with ctetable as not materialized ( select 1 as f1 )
select * from ctetable c1
where f1 in ( select c3.f1 from ctetable c2 full join ctetable c3 on true );
with ctetable as not materialized ( select 1 as f1 )
select * from ctetable c1
where f1 in ( select c3.f1 from ctetable c2 full join ctetable c3 on true );
