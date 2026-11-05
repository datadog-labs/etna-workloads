# Rationale

File: src/backend/regex/regc_nfa.c

- `optimize()`: removed the call to `fixconstraintloops()` (fix hunk adding that call). Constraint-arc loops are no longer eliminated before pullback/pushfwd.
- `pull()`: replaced `assert(from != to)` with the old "circular constraint is pointless" freearc/return 1 (fix hunk in pull()).
- `push()`: same for `assert(to != from)` (fix hunk in push()).

The new helper functions are left in place but unused. Without loop removal, multi-state loops of constraint arcs make pullback/pushfwd loop or misbehave, which is the original bug.

Failing oracle case: src/test/regress||regex
