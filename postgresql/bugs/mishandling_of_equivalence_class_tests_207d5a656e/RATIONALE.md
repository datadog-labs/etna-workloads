# Rationale

Changed: src/backend/optimizer/util/relnode.c, `get_joinrel_parampathinfo`.
Traces to the relnode.c hunks of fix.patch. The `dropped_ecs` list and the
second pass are removed. Clauses movable into the RHS are again dropped
without remembering their EC, and the extra
`generate_join_implied_equalities_for_ecs` call is gone. The original
condition (`!movable(LHS) && !movable(RHS)`) is restored.

Effect: for an EC {X,Y,Z} with Z in required_outer and an inner path
parameterized by X and Z, no clause enforcing Z=X is added at the join. The EC
is under-enforced, so the parameterized plan gives wrong results.

I did not remove `generate_join_implied_equalities_for_ecs` in equivclass.c or
paths.h. It is now unused, but removing it would not change behavior.

Failing oracle case: src/test/regress||join
