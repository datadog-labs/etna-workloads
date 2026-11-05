# Rationale

File: src/backend/commands/view.c, function DefineVirtualRelation (replace branch).
Traces to the fix.patch hunks that reorder CREATE OR REPLACE VIEW: the options update (AT_ReplaceRelOptions) and the AT_AddColumnToView commands are again run together in one AlterTableInternal call, *before* StoreViewQuery. In the fix, the view query is stored first, then the options are updated. With the old order, new options such as WITH CHECK OPTION are validated against the old view query, so replacing a non-updatable view with an updatable one that adds a check option fails. The query store and CommandCounterIncrement stay in this function, after the options and column changes.

Failing oracle case: src/test/regress||updatable_views
