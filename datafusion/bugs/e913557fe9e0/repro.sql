CREATE TABLE t21176 (col_a TEXT, col_b DOUBLE, col_c TEXT) AS VALUES
  ('a-0', 0, 'c-0'), ('a-1', 1, 'c-1'), ('a-2', 2, 'c-2'), ('a-3', 3, 'c-3'),
  ('a-4', 4, 'c-4'), ('a-5', 5, 'c-5'), ('a-6', 6, 'c-6'), ('a-7', 7, 'c-7'),
  ('a-8', 8, 'c-8'), ('a-9', 9, 'c-9'), ('a-10', 10, 'c-10'), ('a-11', 11, 'c-11');
SELECT col_c, col_b FROM t21176 LIMIT 5;
