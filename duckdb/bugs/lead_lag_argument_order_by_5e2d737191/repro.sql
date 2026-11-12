.mode list
.nullvalue NULL
SELECT 
	i,
	(i * 29) % 11 AS outside,
	i // 2 AS inside,
	lead(i, 1, NULL ORDER BY inside DESC, i) OVER w,
	lag(i, 1, NULL ORDER BY inside DESC, i) OVER w,
FROM range(10) tbl(i)
WINDOW w AS (
	ORDER BY outside
)
ORDER BY inside DESC, i;
SELECT 
	i,
	i // 2 AS inside,
	lead(i, 1, NULL ORDER BY i // 2, i) OVER w AS next,
	lag(i, 1, NULL ORDER BY i // 2, i) OVER w AS prev,
FROM range(10) tbl(i)
WINDOW w AS (
	ORDER BY i // 2
	ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
)
ORDER BY i;
CREATE TABLE issue17266(c1 INT, c2 SMALLINT, c3 BITSTRING);
INSERT INTO issue17266 VALUES
(0, null, null),
(1, 32767, '101'),
(2, -32767, '101'),
(3, 0, '000'),
(4, 1, '010'),
(5, 0, '110'),
(6, null, null);
SELECT
	c1,
        c3,
        c2,
        LAG(c3, c2 ORDER BY c1, BITSTRING'010101010') OVER (PARTITION BY c1 ORDER BY c3)
FROM issue17266
ORDER BY c1;
SELECT
	c1,
        c3,
        c2,
        LEAD(c3, c2 ORDER BY c1, BITSTRING'010101010') OVER (PARTITION BY c1 ORDER BY c3)
FROM issue17266
ORDER BY c1;
CREATE TABLE issue25699(id INTEGER, x VARCHAR);
INSERT INTO issue25699 VALUES (1, 'b'), (2, 'a');
SELECT
	id,
	x,
	LEAD(x ORDER BY x DESC, id DESC) OVER w,
	LEAD(x ORDER BY x DESC, id ASC) OVER w
FROM issue25699
WINDOW w AS (ORDER BY x DESC, id ASC ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING)
ORDER BY id;
