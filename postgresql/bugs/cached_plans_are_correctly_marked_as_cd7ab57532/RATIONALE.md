# Rationale
All changes in src/backend/rewrite/rewriteHandler.c, reversing the fix's propagation of hasRowSecurity (the fix's rewriteHandler.c hunks):
- ApplyRetrieveRule: removed `parsetree->hasRowSecurity |= rule_action->hasRowSecurity` (views with RLS).
- fireRIRonSubLink: removed `context->hasRowSecurity |= ...` (sublinks).
- fireRIRrules: removed the same propagation for RTE_SUBQUERY, CTEs, and the sublink context merge.
Without these, a query that gets RLS only via a view/subquery/CTE/sublink is not marked hasRowSecurity, so cached plans are not invalidated on role change (not marked role-dependent).
(The context struct is kept; it's still used but its result is now ignored.)

Failing oracle case: src/test/regress||rowsecurity
