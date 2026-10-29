repro.sql (from transitive1-1110): t1.x='ABC', t2.y='abc'; query joins on
`(t1.x COLLATE nocase) = (t2.y COLLATE nocase) AND t2.y = 'ABC'`.
The correct result is no rows (t2.y='ABC' is false under BINARY). The buggy shell
treats the explicit-COLLATE equality as a transitive equivalence and returns `ABC|abc`.
