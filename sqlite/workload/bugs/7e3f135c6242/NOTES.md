`repro.sql` loads (via `.open --hexdb`) the test's database, whose generated column is
`b AS((VALUES(1)) IS unknown)` (a subquery, invalid in a generated column). It turns
defensive mode off, sets `writable_schema=ON` so the bad schema loads, then runs
`REPLACE INTO t1 VALUES(9); SELECT a, quote(b) FROM t1;`.

Clean shell prints `9|NULL` (the broken expression was replaced by NULL).
Buggy shell prints `9|0`: the broken expression is kept and evaluated.
