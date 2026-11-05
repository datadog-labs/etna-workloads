# Rationale

The current code no longer uses null Consts in indextlist. It marks non-returnable columns as resjunk in create_indexscan_plan and drops them in setrefs.c. This is the same intent as the original fix, expressed differently.

## Changed hunk
- File: src/backend/optimizer/plan/setrefs.c, function set_indexonlyscan_references.
- Traces to: the fix.patch hunks that keep setrefs.c from matching non-returnable index columns. In the original, make_indexonly_tlist replaced those columns with null Consts. Here the equivalent is the resjunk filtering.
- Change: removed the loop that built stripped_indextlist, so build_tlist_index now uses plan->indextlist directly.
- Why it brings the bug back: setrefs can again match an expression against a non-returnable index column. An index-only scan then reads that column instead of recomputing the expression from the returnable column.

## Failing oracle cases
- src/test/regress||gist
