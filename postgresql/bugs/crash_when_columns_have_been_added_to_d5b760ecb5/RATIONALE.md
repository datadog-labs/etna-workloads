# Rationale

The fix added `if (!aliasp_item) break;` in expandRTE's RTE_SUBQUERY case, so extra view columns were ignored. Current code evolved: ApplyRetrieveRule pads colnames, and expandRTE just errors. Both are removed to restore the original bug.

1. src/backend/parser/parse_relation.c, expandRTE (RTE_SUBQUERY): removed the `!aliasp_item` check (the fix.patch hunk in the same place). `lfirst(aliasp_item)` then dereferences NULL when the subquery tlist has more columns than the colnames list, which crashes.
2. src/backend/rewrite/rewriteHandler.c, ApplyRetrieveRule: removed the loop that pads rte->eref->colnames with "?column?" (and unused `numCols`). This cleanup is the later replacement for the fix's tolerance, and it would hide the bug, so the state of a view with columns added at the end now reaches expandRTE.

Failing oracle case: src/test/regress||alter_table
