# Rationale

Changed hunk: src/backend/utils/adt/ruleutils.c, `set_relation_column_names()` (loop over the RTE's colnames, about line 4450).

Traces to the ruleutils.c hunk of fix.patch. The fix treats an empty-string column name in eref as a dropped column and sets it to NULL. I restored the original `real_colnames[i] = strVal(lfirst(lc));`. A dropped column in a composite-returning function's RTE now keeps its empty name, so the deparsed output is wrong.

The outfuncs.c hunk (`_outValue` empty-string handling) is not applied. That code no longer exists in the current tree, because node output was rewritten.

Failing oracle case: src/test/regress||create_view
