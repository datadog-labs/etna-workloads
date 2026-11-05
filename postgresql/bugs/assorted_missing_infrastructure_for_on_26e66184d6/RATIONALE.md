# Rationale

1. src/backend/optimizer/plan/planner.c, subquery_planner(): removed the preprocess_expression() calls
   for onConflict->arbiterElems and arbiterWhere (fix_impl.patch planner.c hunk). Arbiter expressions
   are no longer const-simplified or converted to implicit-AND form, so index inference misbehaves.
2. src/backend/catalog/dependency.c, find_expr_references_walker(): removed the OnConflictExpr branch
   (fix_impl.patch dependency.c hunk). A rule or view using ON CONFLICT ON CONSTRAINT no longer records a
   dependency on the constraint.

Failing oracle case: src/test/regress||insert_conflict (it fails with change 1 alone; change 2 alone did not fail it).
