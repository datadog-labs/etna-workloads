# Rationale

Today's code no longer fixes the nullingrels in process_subquery_nestloop_params
(fix.patch hunk in paramassign.c); the adjustment was moved into
identify_current_nestloop_params, which forces Var nullingrels to
`rel->nulling_relids ∩ leftrelids`. Re-expressing the bug there:

- src/backend/optimizer/util/paramassign.c, identify_current_nestloop_params:
  removed the `var->varnullingrels = bms_intersect(...)` overwrite for Vars.
  Traces to the fix's paramassign.c hunks that adjust (strip) varnullingrels of
  subquery nestloop params. Without it, lateral subquery Vars keep the parser's
  "b*" nullingrels (including the A/B join) although the nestloop's outer side
  only provides "b", yielding wrong varnullingrels.

The setrefs.c hunk is comment-only.

Failing oracle case: src/test/regress||join
