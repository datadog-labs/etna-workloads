# Rationale

The fix added `EP_Collate` guards in two places. Version-3.54.1 already had
equivalent guards in different form; both were removed.

1. `src/whereexpr.c`, `termIsEquivalence()`: the fix added
   `if( ExprHasProperty(pExpr, EP_Collate) ) return 0;`. In 3.54.1 that check is
   folded into condition (3) as `EP_OuterON|EP_Collate`. I reduced it to
   `EP_OuterON`, so an equality with an explicit COLLATE term is again treated
   as a transitive equivalence.
2. `src/wherecode.c`, `sqlite3WhereCodeOneLoopStart()`: the fix added
   `if( ExprHasProperty(pAlt->pExpr, EP_Collate) ) continue;` in the loop that
   looks for alternate equivalent terms. I deleted that line.

## Oracle failures
- transitive1-1010: expected 4 rows, got `Hello Hello`. The COLLATE NOCASE
  term is wrongly used to derive a constant for `t1.a = t2.b`.
- transitive1-1110: expected no rows, got `ABC abc`. The equivalence between
  `x COLLATE nocase` and `y COLLATE nocase` was used to substitute `y='ABC'`.
