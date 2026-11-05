# Rationale

File: src/backend/optimizer/path/allpaths.c, function add_paths_to_append_rel()
Traces to the single fix_impl.patch hunk. The startup-subpath check was changed from
`childrel->cheapest_startup_path != NULL` back to
`childrel->pathlist != NIL && childrel->cheapest_startup_path->param_info == NULL`.
A child whose pathlist is non-empty can still have cheapest_startup_path unset (NULL),
so the dereference crashes. The fix's extra branch around the Assert is not reproduced
because the current code already has an equivalent block structure.

Failing oracle case: src/test/regress||union
