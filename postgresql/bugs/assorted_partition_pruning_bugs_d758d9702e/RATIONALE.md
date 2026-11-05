# Rationale

File: src/backend/partitioning/partprune.c, function match_clause_to_partition_key (ScalarArrayOpExpr branch).
Traces to the fix_impl.patch hunks in that same branch:

1. Right-hand-side handling: `else if (IsA(rightop, ArrayExpr))` plus the final
   `else { return PARTCLAUSE_UNSUPPORTED; }` reverted to a plain `else` that does
   castNode(ArrayExpr, rightop). Any array operand that is neither a Const nor an
   ArrayExpr now hits a failed cast instead of being given up on.
2. After gen_partprune_steps_internal: removed
   `else if (*clause_steps == NIL) return PARTCLAUSE_UNSUPPORTED;`. When step
   generation yields no steps, MATCH_STEPS is returned with an empty list.

Other hunks of the original patch (saop_op, negator, contradictory variable) are already
equivalent or restructured in today's code, so were not changed.

Failing oracle case: src/test/regress||partition_prune
