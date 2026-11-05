Changed: src/backend/optimizer/path/allpaths.c, generate_useful_gather_paths().
Traces to the fix_impl.patch hunk that changed the call to get_useful_pathkeys_for_relation(root, rel, true).
The call now passes require_parallel_safe=false, so pathkey expressions that are not parallel safe are
accepted and a sort can be pushed below Gather Merge. (The parameter plumbing already exists and is left in place.)

Failing oracle case: src/test/regress||incremental_sort
