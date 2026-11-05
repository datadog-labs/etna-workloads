# Rationale
File: src/backend/optimizer/util/inherit.c, function apply_child_basequals (the code moved here from set_append_rel_size in allpaths.c).

Traces to the fix.patch hunks in allpaths.c, set_append_rel_size. The fix re-added `foreach(lc2, make_ands_implicit(childqual))` so that an AND clause returned by eval_const_expressions is flattened into separate RestrictInfos. I removed that loop. The whole childqual is now wrapped in a single RestrictInfo, and the `lc2` variable is dropped. As a result, an AND-clause child qual becomes a RestrictInfo whose clause is a BoolExpr AND. That is not allowed, and it triggers the Assert failure.

Failing oracle case: src/test/regress||union
