create table t as select g % 10 as ten from generate_series(1,1000) g;
select * from
  (select generate_series(1, ten) as g, count(*) from t group by 1) ss
  where ss.g = 1;
