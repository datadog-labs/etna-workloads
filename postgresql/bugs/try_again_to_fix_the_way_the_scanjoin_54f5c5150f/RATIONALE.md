# Rationale

File/function: src/backend/optimizer/plan/planner.c, apply_scanjoin_target_to_paths (the descendant of the grouping_planner code in fix_impl.patch).

Traces to the fix.patch hunk in grouping_planner that applies scanjoin_target to every partial path of the scan/join rel (the loop using create_projection_path on current_rel->partial_pathlist). I removed the "Likewise adjust the targets for any partial paths" loop. Partial paths keep the old reltarget while the complete paths and rel->reltarget use the new scan/join target. Upper planning that builds on partial paths (Gather, partial aggregation) then gets paths whose output doesn't match the final scan/join target, which is the bug the fix removed.

Failing oracle case: src/test/regress||select_parallel
