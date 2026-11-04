CREATE TABLE orders(order_id INT, customer_id INT, o_item_id INT) AS VALUES (1,2,3);
SELECT order_id FROM orders UNION SELECT customer_id, o_item_id FROM orders;
SELECT order_id FROM orders UNION ALL SELECT customer_id, o_item_id FROM orders;
