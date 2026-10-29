repro.sql: t1.a is BINARY text, t2.b is NOCASE text, both hold 'abc'.
`SELECT * FROM t1 CROSS JOIN t2 WHERE a=b AND b='ABC'` should return `abc|abc`
(b='ABC' matches under NOCASE; a=b matches). With the bug, a=b is treated as an
equivalence despite differing collations, so 'ABC' is propagated to a (a='ABC',
BINARY) and the query returns no rows.
