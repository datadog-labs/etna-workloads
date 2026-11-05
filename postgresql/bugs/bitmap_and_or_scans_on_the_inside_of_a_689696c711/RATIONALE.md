# Rationale

File: src/backend/optimizer/util/pathnode.c, functions `create_bitmap_and_path` and `create_bitmap_or_path`.

Traces to the fix.patch pathnode.c hunks that compute `required_outer` as the union of child PATH_REQ_OUTER and set `param_info` via `get_baserel_parampathinfo`. I reverted both to `param_info = NULL` ("not used in bitmap trees"), as before the fix.

Why this brings back the bug: BitmapAnd/BitmapOr paths no longer carry parameterization. `reparameterize_path_by_child` returns a path unchanged when `PATH_REQ_OUTER` is empty. A bitmap AND/OR on the inside of a partitionwise nestloop join therefore isn't translated to the child rel, so the plan is wrong or fails.

I did not restore the old `get_bitmap_tree_required_outer` in indxpath.c, so the cost-estimation code is unchanged. It reads PATH_REQ_OUTER of the And/Or nodes, which is now empty.

Failing oracle case: src/test/regress||partition_join
