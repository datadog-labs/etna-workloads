SELECT regexp_count('abc', NULL::text) AS a, regexp_count('abc', 'b', 1, NULL::text) AS b;
SELECT regexp_count(s, r) AS c FROM (VALUES ('abc','b'),('abc',NULL)) t(s,r);
SELECT regexp_count(s, NULL, 1) FROM (VALUES ('abc'),('abd')) t(s);
SELECT regexp_instr('abc', NULL::text) AS a;
SELECT regexp_instr(s, r) AS c FROM (VALUES ('abc','b'),('abc',NULL)) t(s,r);
