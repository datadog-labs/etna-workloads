# Rationale

The fix added an early `return -1` in `find_compatible_pertrans` (nodeAgg.c) so ordered-set aggregates never share transition states. That logic now lives in the planner (`src/backend/optimizer/prep/prepagg.c`), where the equivalent guard is the `shareable` flag (false for aggregates whose finalfn is AGGMODIFY_READ_WRITE, which includes the built-in OSAs).

Hunks, both in prepagg.c, both tracing to the single fix_impl.patch hunk (the "never share for OSAs" check):
- `find_compatible_trans`: removed `if (!shareable) return -1;`.
- `find_compatible_agg`: removed the `if (agginfo->shareable)` condition on collecting `same_input_transnos`.

Together, destructive-finalfn aggregates (OSAs) can again share a transition state, so the second finalfn sees a state already destroyed by the first.

Failing oracle case: src/test/regress||aggregates
