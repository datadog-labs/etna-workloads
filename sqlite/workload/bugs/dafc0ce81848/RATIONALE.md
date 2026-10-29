# Rationale

Fix (check-in 5026) moved the ticket #3015 LEFT JOIN ON-clause restriction
from an immediate `pTerm->prereqRight |= x-1` into a saved `extraRight` that is
applied at the end of exprAnalyze() (and into the commuted copy), because the
early assignment was overwritten when the term was commuted (`x=b` form).

In `tree/src/whereexpr.c` (exprAnalyze) I restored the pre-fix form:
- removed the `extraRight` variable; the OuterON branch again does
  `pTerm->prereqRight |= x-1` immediately (hunk 2 of fix reversed).
- `pNew->prereqRight = prereqLeft | extraRight` -> `prereqLeft` (the commuted
  term no longer carries the extra dependency, so the early value is lost).
- removed the final `pTerm->prereqRight |= extraRight` (hunk 3 of fix) and the
  `| extraRight` in the MATCH virtual-term path, which is the same defect
  (a later addition of the same mechanism).

Failing oracle cases: where3-1.1.1, where3-1.2.1, where6-1.5, where6-1.6,
where6-2.3, where6-2.4, where6-2.5, where6-2.6 — the EXPLAIN output for
`ON x=b` / `ON q=x` differs from the `b=x` form, since the commuted term
becomes usable as an index driver for the left table of the LEFT JOIN.
