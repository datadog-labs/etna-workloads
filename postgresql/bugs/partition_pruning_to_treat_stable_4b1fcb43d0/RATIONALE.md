# Rationale

File: src/backend/partitioning/partprune.c, function match_clause_to_partition_key (two hunks: OpExpr branch and ScalarArrayOpExpr branch).

Traces to fix.patch hunks that add, for forplanner, the check `op_volatile(opno) != PROVOLATILE_IMMUTABLE -> PARTCLAUSE_UNSUPPORTED`
(in today's code: `if (context->target == PARTTARGET_PLANNER) return PARTCLAUSE_UNSUPPORTED;` inside the mutable-operator check).
I removed that early return. Planner-time pruning then uses stable comparison operators (evaluated at plan time),
though such operators must only be used at execution time.

Failing oracle case: src/test/regress||partition_prune (see oracle output).
