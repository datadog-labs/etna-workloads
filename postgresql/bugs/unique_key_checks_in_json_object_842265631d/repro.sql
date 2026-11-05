select left(json_object_agg_unique(mod(i,100), i)::text, 20) from generate_series(0, 199) i;
SELECT left(JSON_OBJECT(1: 1, '2': NULL, '3': 1, repeat('x', 1000): 1, 2: repeat('a', 100) WITH UNIQUE)::text, 20);
