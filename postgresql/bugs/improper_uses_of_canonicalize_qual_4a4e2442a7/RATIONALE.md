# Rationale
The fix made canonicalize_qual() take is_check, so CHECK-style quals treat constant NULL as TRUE (OR) / dropped (AND) rather than as FALSE. Reintroduced the misuse by passing is_check=false at CHECK-constraint call sites (the pre-fix behavior treated all as WHERE quals):
- src/backend/catalog/partition.c get_proposed_default_constraint: canonicalize_qual(..., true) -> false (partition.c hunk of fix.patch).
- src/backend/commands/tablecmds.c PartConstraintImpliedByRelConstraint: true -> false (tablecmds.c hunk).
- src/backend/optimizer/util/plancat.c get_relation_constraints: CHECK constraints true -> false (plancat.c hunk).
CHECK constraints containing NULL constants are then simplified as if in WHERE, giving wrong constraint-exclusion/implication results.

Failing oracle case: src/test/regress||inherit
