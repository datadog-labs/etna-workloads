# Rationale

## src/backend/optimizer/prep/prepjointree.c, pullup_replace_vars_callback()
Traces to the single hunk in fix_impl.patch. In the `PlaceHolderVar` branch
(newnode is a PHV with phlevelsup == 0), the current code wraps the PHV in another
PHV when the target RTE is LATERAL and the PHV's phrels are not within the
subquery's relids and nullingrels differ. This was reverted to the pre-fix
behavior: `wrap = false` unconditionally. A lateral reference to a PHV from
outside the subquery, under a different nulling outer join, then no longer gets
a wrapper, which gives wrong results or planner errors.

## Failing oracle cases
- src/test/regress||join
