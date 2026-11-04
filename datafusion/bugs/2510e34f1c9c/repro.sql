create table t (a int, b int) as values (1,2), (2,3), (3,4), (4,5), (5,6);
select count(*) from (select * from t x cross join (select unnest([1,2,3]) limit 1) limit 10);
