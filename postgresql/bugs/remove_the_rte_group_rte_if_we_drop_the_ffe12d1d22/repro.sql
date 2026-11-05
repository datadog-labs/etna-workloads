create temp table t(a int, b int);
explain (costs off)
select a.* from t a
where exists (select 1 from t b where a.a = b.b group by b.a);
select 1;
