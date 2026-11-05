# Rationale

## src/backend/rewrite/rowsecurity.c, get_row_security_policies() (CMD_MERGE branch)
Traces to the rowsecurity.c hunks of fix.patch. The fix gave UPDATE, DELETE and INSERT
separate policy lists, so the WCO_RLS_UPDATE_CHECK WITH CHECK options use the UPDATE
policies. The current code already has the separate lists, so I reversed only the behaviour.
I moved the WCO_RLS_UPDATE_CHECK add_with_check_options() call from just after the UPDATE
policy fetch to after the INSERT one, and made it use merge_insert_*_policies. MERGE ... UPDATE
actions therefore have their new rows checked against INSERT policies instead of UPDATE WITH CHECK policies.

The nodeModifyTable.c hunk in fix_impl.patch (the `commandType != CMD_NOTHING` guard in ExecMerge)
was not reverted. The bug reproduces without it.

## Failing oracle cases
- src/test/regress||rowsecurity
