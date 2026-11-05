# Rationale

## src/backend/rewrite/rewriteHandler.c, ApplyRetrieveRule()
Traces to the fix_impl.patch hunks that move the `markQueryForLocking()` call
from after the RTE-to-subquery conversion to before `fireRIRrules()`.
The bug is restored by moving the call back to the end of the function (after
`fireRIRrules()` and the conversion). Sub-views are then expanded before their
RTE_RELATION RTEs are marked, so the needed UPDATE permission bits are not
applied to the sub-view's base relations and then transferred to its OLD RTE.
SELECT FOR UPDATE on nested views therefore skips the UPDATE privilege check.

## Failing oracle cases
src/test/regress||updatable_views (see oracle output)
