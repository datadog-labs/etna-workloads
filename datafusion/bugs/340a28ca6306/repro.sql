SELECT starts_with(a, 'foo_') FROM (VALUES ('foobar'), ('foo_bar')) AS t(a) ORDER BY a;
SELECT starts_with(a, 'foo\_') FROM (VALUES ('foobar'), ('foo\\_bar'), ('foo\_bar')) AS t(a) ORDER BY a;
EXPLAIN SELECT starts_with(a, 'f_o') FROM (VALUES ('foobar')) AS t(a);
