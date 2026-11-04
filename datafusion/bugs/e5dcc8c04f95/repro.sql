create table t(x int, y int) as values (1,1), (2,2), (3,3), (0,0), (4,0);
select coalesce(1, y/x), coalesce(2, y/x) from t;
