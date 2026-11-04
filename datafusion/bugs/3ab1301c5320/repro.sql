SELECT split_part('a,b', '', 1), split_part('a,b', '', -1), split_part('a,b', '', 2), split_part('a,b', '', -2);
SELECT s, split_part(s, d, n) AS r FROM (VALUES ('a,b', '', 1), ('a,b', '', -1), ('a,b', '', 2), ('a,b', '', -2)) t(s, d, n) ORDER BY n;
