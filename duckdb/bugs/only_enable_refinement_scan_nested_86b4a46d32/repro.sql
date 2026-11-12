.mode list
.nullvalue NULL
SELECT a, b,
       row(a, b) IN (SELECT * FROM (VALUES (2, 6), (3, 7), (3, NULL::INT), (4, 8)) rhs(x, y)),
       row(a, b) NOT IN (SELECT * FROM (VALUES (2, 6), (3, 7), (3, NULL::INT), (4, 8)) rhs(x, y))
FROM (VALUES (1, 5), (2, 6), (3, 9), (9, 8), (3, NULL::INT),
             (NULL::INT, 8), (NULL::INT, NULL::INT)) lhs(a, b);
SELECT a, b,
       row(a, b) IN (SELECT * FROM (VALUES (2, 6), (NULL::INT, 7), (4, NULL::INT),
                                           (NULL::INT, NULL::INT)) rhs(x, y)),
       row(a, b) NOT IN (SELECT * FROM (VALUES (2, 6), (NULL::INT, 7), (4, NULL::INT),
                                               (NULL::INT, NULL::INT)) rhs(x, y))
FROM (VALUES (1, 5), (2, 6), (3, 7), (4, 8)) lhs(a, b);
SELECT row(NULL::INT, 8) IN (SELECT * FROM (VALUES (2, 6), (3, 7)) rhs(x, y)),
       row(NULL::INT, 8) NOT IN (SELECT * FROM (VALUES (2, 6), (3, 7)) rhs(x, y));
SELECT k,
       row(a, b, c, d, e, f) IN (
           SELECT * FROM (VALUES (1, 1, 1, 1, 1, 1),
                                 (0, NULL::INT, NULL::INT, 0, NULL::INT, 0)) rhs(a, b, c, d, e, f)),
       row(a, b, c, d, e, f) NOT IN (
           SELECT * FROM (VALUES (1, 1, 1, 1, 1, 1),
                                 (0, NULL::INT, NULL::INT, 0, NULL::INT, 0)) rhs(a, b, c, d, e, f))
FROM (VALUES ('k1', 1, 1, 1, 1, 1, 1),
             ('k2', 0, 0, 0, 0, 0, 0),
             ('k4', 1, 0, 0, 0, 0, 0),
             ('k8', 0, 1, 1, 0, 1, 0)) lhs(k, a, b, c, d, e, f);
SELECT row(1, 2) IN (SELECT * FROM (VALUES (1, 2)) rhs(x, y) WHERE false),
       row(1, 2) NOT IN (SELECT * FROM (VALUES (1, 2)) rhs(x, y) WHERE false);
SELECT row(1, 2) IN (SELECT * FROM (VALUES (NULL::INT, NULL::INT)) rhs(x, y)),
       row(1, 2) NOT IN (SELECT * FROM (VALUES (NULL::INT, NULL::INT)) rhs(x, y));
SELECT *
FROM (VALUES (0, 0), (1, 0)) outer_tab(f1, f2)
WHERE (f1, f2) NOT IN (
	SELECT * FROM (VALUES (0, NULL::INT)) inner_tab(c1, c2)
)
ORDER BY ALL;
CREATE TABLE mark_join_rhs AS SELECT i::INT AS a, i::INT AS b FROM range(3000) t(i);
INSERT INTO mark_join_rhs VALUES (NULL, 7);
SELECT row(4000, 7) IN (SELECT a, b FROM mark_join_rhs),
       row(4000, 7) NOT IN (SELECT a, b FROM mark_join_rhs);
SELECT row(NULL::INT, 4001) IN (SELECT a, b FROM mark_join_rhs),
       row(NULL::INT, 4001) NOT IN (SELECT a, b FROM mark_join_rhs);
SELECT row([1, NULL::INT], 0) IN (
	SELECT * FROM (VALUES ([1, 2], 0)) rhs(a, b)
);
SELECT row([1, NULL::INT], 0) IN (
	SELECT * FROM (VALUES ([1, NULL::INT], 0)) rhs(a, b)
);
SELECT row([1, 2], 0) IN (
	SELECT * FROM (VALUES ([1, NULL::INT], 0)) rhs(a, b)
);
SELECT row(array_value(1, 2), 0) IN (
	       SELECT * FROM (VALUES (array_value(1, NULL::INT), 0)) rhs(a, b)
       ),
       row(map([1, 2], [1, 2]), 0) IN (
	       SELECT * FROM (VALUES (map([1, 2], [1, NULL::INT]), 0)) rhs(a, b)
       ),
       row({'a': 1, 'b': 2}, 0) IN (
	       SELECT * FROM (VALUES ({'a': 1, 'b': NULL::INT}, 0)) rhs(a, b)
       ),
       row(union_value(num := 1)::UNION(num INT, str VARCHAR), 0) IN (
	       SELECT *
	       FROM (VALUES (union_value(num := NULL::INT)::UNION(num INT, str VARCHAR), 0)) rhs(a, b)
       );
SELECT row(array_value(1, NULL::INT), 0) IN (
	SELECT * FROM (VALUES (array_value(1, 2), 0)) rhs(a, b)
);
SELECT row(map([1, 2], [1, NULL::INT]), 0) IN (
	SELECT * FROM (VALUES (map([1, 2], [1, 2]), 0)) rhs(a, b)
);
SELECT row({'a': 1, 'b': NULL::INT}, 0) IN (
	SELECT * FROM (VALUES ({'a': 1, 'b': 2}, 0)) rhs(a, b)
);
SELECT row(union_value(num := NULL::INT)::UNION(num INT, str VARCHAR), 0) IN (
	SELECT * FROM (VALUES (union_value(num := 1)::UNION(num INT, str VARCHAR), 0)) rhs(a, b)
);
SELECT row([9, NULL::INT], 0) IN (
	SELECT * FROM (VALUES ([1, 2], 0)) rhs(a, b)
);
SELECT count(*)
FROM range(10000) lhs(i)
WHERE row(list_value(i), 0::INT) NOT IN (
	SELECT list_value((i + 100000)::BIGINT), 0::INT
	FROM range(10000) rhs(i)
);
SELECT count(*), count(marker), count_if(marker)
FROM (
	SELECT row(i, 0::INT) IN (
		SELECT a, b
		FROM (
			SELECT i::BIGINT AS a, 0::INT AS b FROM range(100000) rhs(i)
			UNION ALL
			SELECT NULL::BIGINT, 0::INT
		)
	) AS marker
	FROM range(100000) lhs(i)
);
SELECT row(1, 2) = ANY (
	SELECT s FROM (VALUES (row(1, NULL::INT))) rhs(s)
);
