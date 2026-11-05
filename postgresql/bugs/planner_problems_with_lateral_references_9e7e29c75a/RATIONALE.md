# Rationale

## Changed hunk
- File: `src/backend/optimizer/util/placeholder.c`, function `find_placeholder_info`.
- Traces to the `placeholder.c` hunk of fix.patch that replaces
  `ph_eval_at = pull_varnos((Node *) phv)` with the split into `ph_lateral`
  (rels outside `phv->phrels`) and `ph_eval_at` (`rels_used ∩ phv->phrels`).
- Reverted logic: `ph_eval_at` is again the full set of rels referenced by the
  PHV expression, and `ph_lateral` is left empty. LATERAL references to rels
  outside the PHV's syntactic scope therefore raise `ph_eval_at` above its
  syntactic level instead of becoming a lateral-reference requirement on the
  `ph_eval_at` relation. This is the bug the fix removed. The planner then
  evaluates the PHV at the wrong join level and gets the wrong join
  placement or plan.
- The rest of the original fix has since been reworked upstream
  (`direct_lateral_relids`, `lateral_vars`, and so on). This one hunk is the
  point where the bug originates.

## Failing oracle cases
- `src/test/regress||join`
