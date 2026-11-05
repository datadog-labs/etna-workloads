Changes re-introduce the missing exclRelTlist/exclRelIndex handling for ON CONFLICT:
- nodeFuncs.c expression_tree_walker (T_OnConflictExpr): removed walking of exclRelTlist (fix hunk 2a).
- nodeFuncs.c expression_tree_mutator: removed MUTATE of exclRelTlist (hunk 2b).
- setrefs.c set_plan_refs (ModifyTable): removed fix_scan_list of splan->exclRelTlist (hunk 3).
- rewriteManip.c OffsetVarNodes and ChangeVarNodes: removed exclRelIndex adjustment (hunks 4, 5).
Effect: rules with ON CONFLICT get stale/unadjusted EXCLUDED varnos and unwalked tlist.
(The nodeModifyTable.c hunk was only a comment.)
Failing oracle case: src/test/regress||rules
