`x IN (y)` with a single non-constant RHS must behave like `x==(+y)` (no affinity, binary collation).
The buggy shell turns it into plain `x==y`, so affinity/collation of y leak in.
repro.sql: `a IN (b)` with a TEXT '1.0' and b NUMERIC 1 returns no row on clean, 4 on buggy;
`(a||'') IN (b)` with b NOCASE returns only 3 on clean, 1 and 3 on buggy.
