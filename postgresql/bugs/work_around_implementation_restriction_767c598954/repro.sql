create temp table t4(f1 int);
explain (verbose, costs off)
select * from t4 left join (
  select text 'foo' union all select text 'bar'
) ss(x) on true
where ss.x is null;
