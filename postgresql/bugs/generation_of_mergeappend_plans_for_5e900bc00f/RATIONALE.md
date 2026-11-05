# Rationale

The code is now path-based. The fix's check ("if the top plan node can't project and its tlist differs, add a Result; otherwise replace the tlist") is now handled in `build_minmax_path` by `apply_projection_to_path`, which puts a projection on top of the sorted path if needed.

Changed hunk:

- `src/backend/optimizer/plan/planagg.c`, `build_minmax_path`: removed the `apply_projection_to_path(subroot, final_rel, sorted_path, create_pathtarget(subroot, subroot->processed_tlist))` call. It traces to the single planagg.c hunk in fix.patch, which added the projection-capability check and the Result insertion. Without it, the min/max subplan is never adjusted to the desired target list (`agg_target`, e.g. `1-id`). The path keeps its flat reltarget, so the InitPlan returns the wrong column or expression. This is the same defect as the original: the planner doesn't ensure the plan can produce the desired expression tlist.

The `#include "optimizer/tlist.h"` hunk is not needed in the current code.

I first tried also re-adding `plan->targetlist = subparse->targetList` in `create_minmaxagg_plan`. It crashed `explain select max(100) from tenk1` with an assertion failure in the planner. It didn't make `inherit` fail, because `create_merge_append_plan` already injects a Result in that case. I dropped it as not traceable to a fix hunk.

Failing oracle case: `src/test/regress||inherit`
