create table t(a integer, b integer);
insert into t(a, b) select (case when i < 5 then i else 9 end), i from generate_series(1, 1000) n(i);
analyze t;
select * from (select * from t order by a) s order by a, b limit 5;
