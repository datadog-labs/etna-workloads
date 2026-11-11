Changes (the default-on param and the other FIX.diff hunks are comment, whitespace or already-differing config; only the guard hunks apply in today's code):

1. src/src/ast/rewriter/distribute_forall.cpp -> FIX.diff hunk 1. Removed the `!q->get_num_patterns() && !q->get_num_no_patterns()` guard. Patterned and no-pattern quantifiers get split again, so their annotations are copied or dropped on each conjunct.
2. src/src/ast/simplifiers/distribute_forall.cpp -> FIX.diff hunk 3 (both the forall and exists guards). Removed the same guards, so annotated quantifiers are distributed again.

Result: smt_context fails at test/smt_context.cpp:1117 (`result == patterned`).

Final ./check.sh output:
BUILD OK
FAIL smt_context (rc=114)
    ASSERTION VIOLATION  smt_context.cpp Line: 1117  Failed to verify: result == patterned
