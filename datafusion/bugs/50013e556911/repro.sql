CREATE TABLE t1 AS VALUES (1, 10, 'a'), (2, 20, 'b'), (3, 30, 'c'), (NULL, 40, 'd');
CREATE TABLE t2 AS VALUES (1, 100, 'p'), (2, 200, 'q'), (5, 500, 'r');
select * from t1 left join t2 on t1.column1 = t2.column1 where not ((t2.column2 > 150) is true) order by 1,2;
select * from t1 left join t2 on t1.column1 = t2.column1 where not ((t2.column2 > 150) is false) order by 1,2;
