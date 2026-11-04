SET datafusion.execution.target_partitions = 4;
CREATE TABLE topk(x int) AS VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
select * from (select * from topk limit 8) order by x limit 3;
