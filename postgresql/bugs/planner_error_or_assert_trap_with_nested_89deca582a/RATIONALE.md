# Rationale
- File: src/backend/optimizer/prep/prepunion.c, function build_setop_child_paths (pNumGroups estimation).
- Traces to the fix.patch hunk changing estimate_num_groups' argument from get_tlist_exprs(subquery->targetList) back... i.e. the reverse: use subroot->processed_tlist instead of the original parse targetList.
- Bug: for nested setops, processed_tlist contains "varno 0" Vars from generate_append_tlist, which confuse estimate_num_groups (planner error / assert trap).

Failing oracle case: src/test/regress||union
