SET datafusion.execution.target_partitions = 4;
CREATE TABLE users_with_pk (id INT, name VARCHAR, primary key(id)) AS VALUES (1, 'alice'), (2, 'bob');
CREATE TABLE user_orders (user_id INT, amount INT) AS VALUES (1, 10), (1, 20), (2, 30);
SELECT DISTINCT u.id FROM users_with_pk u LEFT JOIN user_orders o ON u.id = o.user_id ORDER BY u.id;
EXPLAIN SELECT DISTINCT u.id FROM users_with_pk u LEFT JOIN user_orders o ON u.id = o.user_id;
