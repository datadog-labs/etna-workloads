.mode list
.nullvalue NULL
SET threads=1;
SELECT (1, 2) <> ANY (SELECT * FROM (VALUES (1, NULL::INT)) t(x, y));
SELECT (1, 2) <> ANY (SELECT * FROM (VALUES (NULL::INT, 2)) t(x, y));
SELECT (1, 2) <> ANY (SELECT * FROM (VALUES (1, NULL::INT), (1, 2)) t(x, y));
SELECT (NULL::INT, 3) <> ANY (
	SELECT * FROM (VALUES (1, 2)) rhs(a, b)
);
SELECT (3, NULL::INT) <> ANY (
	SELECT * FROM (VALUES (2, 1)) rhs(a, b)
);
SELECT (NULL::INT, 2) <> ANY (
	SELECT * FROM (VALUES (1, 2)) rhs(a, b)
);
SELECT (1, NULL::INT) <> ANY (SELECT * FROM (VALUES (1, 2)) t(x, y));
SELECT (NULL::INT, 2) <> ANY (SELECT * FROM (VALUES (1, 2)) t(x, y));
SELECT (1, NULL::INT) <> ANY (SELECT * FROM (VALUES (2, 2)) t(x, y));
SELECT (1, NULL::INT) <> ANY (SELECT * FROM (VALUES (1, 2), (2, 2)) t(x, y));
SELECT (1, 2) <> ANY (SELECT * FROM (VALUES (1, 2)) t(x, y) WHERE false);
SELECT (1::SMALLINT, 2::SMALLINT) <> ANY (
	SELECT * FROM (VALUES (1::BIGINT, 3::BIGINT)) rhs(a, b)
);
