CREATE TABLE t1(t1_id INT, t1_name TEXT, t1_int INT) AS VALUES
(11, 'a', 1),
(22, 'b', 2),
(33, 'c', 3),
(44, 'd', 4);

CREATE TABLE t2(t2_id INT, t2_name TEXT, t2_int INT) AS VALUES
(11, 'z', 3),
(22, 'y', 1),
(44, 'x', 3),
(55, 'w', 3);

SELECT t1_id, (SELECT case when max(t2.t2_id) > 1 then 'a' else 'b' end FROM t2 WHERE t2.t2_int = t1.t1_int) x from t1 ORDER BY t1_id;

SELECT t1_id, (SELECT max(t2.t2_id) is null FROM t2 WHERE t2.t2_int = t1.t1_int) x from t1 ORDER BY t1_id;

