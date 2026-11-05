# Rationale
File: src/backend/parser/parse_cte.c. Both hunks trace to the two hunks of fix.patch.

1. `WalkInnerWith()` (the fix's makeDependencyGraphWalker hunk, now refactored into this helper): `cell1 = list_head(cstate->innerwiths)` is hoisted back to before the loop, so it is no longer refreshed after the recursive walk.
2. `checkWellFormedRecursionWalker()`: the same change for the non-RECURSIVE case.

Recursion can push or pop `innerwiths`, so the cached ListCell pointer can become stale after a list reallocation or mutation. The following `lfirst(cell1) = lappend(...)` then writes to the wrong cell, or to freed memory.

Failing oracle case: src/test/regress||with
