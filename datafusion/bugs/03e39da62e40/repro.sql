CREATE TABLE unnest_table AS VALUES ([1,2,3], 'a', 1), ([4,5], 'b', 4);
EXPLAIN SELECT * FROM unnest_table u, unnest(u.column1);
SELECT * FROM unnest_table u, unnest(u.column1);
SELECT * FROM unnest(make_array(1,2));
