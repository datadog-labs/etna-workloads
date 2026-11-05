create table t(a int, b int);
insert into t values (1,0),(2,1),(3,0);
select sum(10/b) filter (where b<>0) from t;
select sum(10/b) filter (where b<>0), count(*) from t;
select sum(10/b) filter (where b<>0), sum(a) from t;
select string_agg(a::text,',' order by 10/b) filter (where b<>0) from t;
