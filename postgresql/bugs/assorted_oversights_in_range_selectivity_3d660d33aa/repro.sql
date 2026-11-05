create temp table t(nr numrange);
insert into t select numrange(i,i+1) from generate_series(1,50) i;
insert into t values('empty'),('empty');
analyze t;
select count(*) from t where nr < 'empty';
select count(*) from t where nr > 'empty';
