# Rationale

Hunk: src/backend/optimizer/plan/setrefs.c, set_plan_refs(), case T_Memoize.
Traces to the fix.patch hunk in set_plan_refs() case T_ResultCache (Result Cache is now called Memoize).
I removed the call `set_dummy_tlist_references(plan, rtoffset)` and its comment.
Without it the Memoize node's targetlist is not rewritten to reference its subnode's output (OUTER_VAR),
so the node keeps its original expressions and setrefs leaves them unresolved. That is the original bug.

Failing oracle case: src/test/regress||join
