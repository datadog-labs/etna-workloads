CREATE TABLE t(id INTEGER PRIMARY KEY, j TEXT, x TEXT);
INSERT INTO t VALUES(1,'{"a":1,"e":9}','a'),(2,'{"b":2,"e":9}','b'),(3,'{"c":3,"e":9}','c'),(4,'{"d":4,"e":9}','d');
SELECT json_group_array(json(j)) OVER (ORDER BY id ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING) FROM t;
SELECT json_group_object(x,json(j)) OVER (ORDER BY id ROWS BETWEEN 1 FOLLOWING AND 2 FOLLOWING) FROM t;
SELECT json_group_array(json(j)) FILTER (WHERE id!=2) OVER (ORDER BY id ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) FROM t;
