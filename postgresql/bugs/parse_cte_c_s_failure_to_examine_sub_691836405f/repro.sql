create temp table t(a int);
with recursive a as (select 1 as n union all select n from b),
 b as (with c as (select n from a) insert into t select * from c returning *)
select * from a;
