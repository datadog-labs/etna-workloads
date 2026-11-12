SET disabled_optimizers='statistics_propagation';
CREATE TABLE composite_left AS SELECT (i % 256)::INTEGER a, ((i // 256) % 4)::INTEGER b FROM range(2048) r(i);
CREATE TABLE composite_right AS SELECT (i % 256)::INTEGER x, ((i // 256) % 4)::INTEGER y FROM range(1024) r(i);
EXPLAIN SELECT * FROM composite_left LEFT JOIN composite_right ON a = x AND b = y;
