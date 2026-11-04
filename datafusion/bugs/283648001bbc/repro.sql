SET datafusion.execution.target_partitions = 4;
CREATE TABLE t1(t1_id INT, t1_name TEXT, t1_int INT) AS VALUES (11,'a',1),(22,'b',2),(33,'c',3),(44,'d',4);
CREATE TABLE t2(t2_id INT, t2_name TEXT, t2_int INT) AS VALUES (11,'z',3),(22,'y',1),(44,'x',3),(55,'w',3);
select t1_id from t1 where t1_id > 40 or exists (select 1 from t2 where t2.t2_int = t1.t1_int) order by 1;
select t1_id from t1 where t1_id > 40 or not exists (select 1 from t2 where t2.t2_int > t1.t1_int) order by 1;
