# Rationale

File: src/backend/optimizer/prep/prepunion.c, function build_setop_child_paths (the code that was in recurse_set_operations when the fix was made).

fix.patch hunk: the estimate_num_groups call, which the fix changed from `get_tlist_exprs(subquery->targetList, false)` to `get_tlist_exprs(subroot->parse->targetList, false)`.

In the current code the local `subquery` is already `subroot->parse`. To bring the bug back, the call now reads the target list from the RTE's original subquery, `root->simple_rte_array[rel->relid]->subquery->targetList`. That target list is not the one self-join removal revised, so it can reference removed relids. estimate_num_groups then works from stale expressions.

Failing oracle case: src/test/regress||join
