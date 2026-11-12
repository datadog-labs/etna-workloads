.mode list
.nullvalue NULL
CREATE TABLE tuples AS SELECT * FROM (VALUES ('a' COLLATE NOCASE, 0), ('B', 0)) v(s, i);
SELECT (s, i) FROM tuples ORDER BY (s, i) DESC LIMIT 1;
SELECT max((s, i)) FROM tuples;
