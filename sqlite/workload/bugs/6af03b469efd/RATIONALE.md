# Rationale

Fix: in `exprAnalyze()`, an EP_InnerON term whose prereqs reach a table to the
right of its join gets EP_InnerON cleared, so it becomes an ordinary WHERE term
(deferred past LEFT JOIN null-row processing).

## Changes

1. `src/whereexpr.c` exprAnalyze: removed the
   `else if( (prereqAll>>1)>=x ){ ExprClearProperty(pExpr, EP_InnerON); }` branch.
   This is the fix hunk reversed (pre-fix code did nothing for EP_InnerON).
   Reversing it alone does not reintroduce the bug in 3.54.1, because of (2).

2. `src/wherecode.c` (`sqlite3WhereCodeOneLoopStart` helper, the
   `(jtype & JT_LEFT) && !ExprHasProperty(pE,EP_OuterON)` branch): removed.
   This later code independently defers non-OuterON terms in a LEFT JOIN loop,
   covering the same case a second way. Without it, the InnerON term whose
   iJoin (t1) is ready is coded inside the LEFT JOIN t2 loop as an ON-clause
   term, so the null-extended row is wrongly emitted — the original bug.

## Oracle results

- `join8-13000` fails (returns a row where the empty result is expected): the
  target case.
- `join8-15020` also fails (collateral, from change 2: same
  inner-ON-references-right-table-of-LEFT-JOIN situation).
