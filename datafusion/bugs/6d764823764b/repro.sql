CREATE TABLE outer_table(id INT, value TEXT) AS VALUES (1,'a'),(2,'b'),(3,'c'),(4,'d'),(NULL,'e');
CREATE TABLE inner_table_with_null(id INT, value TEXT) AS VALUES (2,'x'),(NULL,'y');
SET datafusion.optimizer.filter_null_join_keys = true;
SELECT * FROM outer_table WHERE id NOT IN (SELECT id FROM inner_table_with_null) ORDER BY id;
