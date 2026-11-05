set enable_seqscan=off;
create temp table t(a int, b int);
create index on t(a);
explain (verbose, costs off)
select a from t union all select 42 order by 1;
explain (verbose, costs off)
select * from (select 1 as x offset 0) s limit 5;
