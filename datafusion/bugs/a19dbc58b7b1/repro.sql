SELECT regexp_count('abc', '') AS a, regexp_count('abc', '', 2) AS b, regexp_count('abc', '', 1, 'i') AS c, regexp_count('abc', '', 4) AS d, regexp_count('abc', '', 5) AS e;
SELECT regexp_count(v, p) AS n FROM (VALUES ('', ''), ('abc', 'abc'), ('abc', '')) AS t(v, p);
