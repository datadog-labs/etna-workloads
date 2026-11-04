create table t(a int, b varchar);
insert into t values (1, 'x'), (2, 'y');
set datafusion.optimizer.expand_views_at_output = true;
explain select * from t;
select * from t order by a;
select b from t order by b;
