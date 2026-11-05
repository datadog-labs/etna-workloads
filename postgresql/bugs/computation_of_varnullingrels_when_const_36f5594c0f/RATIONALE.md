Hunk: src/backend/optimizer/util/clauses.c, eval_const_expressions_mutator (T_FieldSelect case).
Traces to the fix.patch hunk that adds `newvar->varnullingrels = ((Var *) arg)->varnullingrels;`.
I removed that line, so the Var made when folding FieldSelect-of-whole-row-Var loses the
original's varnullingrels. (The varreturningtype line, added later, is kept.) The folded Var is then
not marked as nullable by outer joins, which gives wrong plans/results.

Failing oracle case: src/test/regress||join
