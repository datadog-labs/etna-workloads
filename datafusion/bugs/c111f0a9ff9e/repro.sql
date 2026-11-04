SELECT 'a' SIMILAR TO NULL;
SELECT NULL SIMILAR TO NULL;
SELECT 'a' NOT SIMILAR TO NULL;
CREATE TABLE t AS SELECT * FROM (VALUES ('user auth failed')) v(s);
CREATE TABLE p AS SELECT * FROM (VALUES ('(auth|login)')) v(pat);
SELECT arrow_cast(t.s, 'Utf8View') SIMILAR TO p.pat FROM t CROSS JOIN p;
SELECT arrow_cast(t.s, 'LargeUtf8') SIMILAR TO p.pat FROM t CROSS JOIN p;
SELECT arrow_cast(t.s, 'Dictionary(Int32, Utf8)') SIMILAR TO p.pat FROM t CROSS JOIN p;
SELECT 1 SIMILAR TO 'a';
