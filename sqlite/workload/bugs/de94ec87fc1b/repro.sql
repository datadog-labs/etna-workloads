CREATE TABLE t1(id INT, k TEXT, v INT);
INSERT INTO t1 VALUES (1,'a',1),(2,'b',2),(3,'c',3),(4,'d',4),(5,'f',5),(6,'g',6),(7,'h',7);
SELECT id, json_group_object(if(id<>1,k),v) OVER
  (ORDER BY id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) FROM t1;
